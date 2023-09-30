use bollard::container::{
    Config, CreateContainerOptions, ListContainersOptions, LogsOptions, RemoveContainerOptions,
    StartContainerOptions,
};
use bollard::models::HostConfig;
use bollard::{Docker, API_DEFAULT_VERSION};
use futures::StreamExt;
use std::collections::HashMap;
use std::default::Default;
use std::{thread, time};

pub async fn launch(unix_socket: Option<&str>, scenario: Option<&str>) -> Result<Docker, bollard::errors::Error> {
    let docker = match unix_socket {
        Some(socket) => Docker::connect_with_unix(socket, 600, API_DEFAULT_VERSION)?,
        None => Docker::connect_with_local_defaults()?,
    };
    let docker_scenario = match scenario {
        Some(scen) => "--feature ".to_string() + scen,
        None => "--feature funded_orchard_mobileclient".to_string(),
    };
    while check_regchest_exists(&docker).await? {
        close(&docker).await.unwrap();
        thread::sleep(time::Duration::from_secs(10))
    }
    create_regchest_container(&docker, &docker_scenario).await?;
    start_regchest_container(&docker).await?;
    wait_for_launch(&docker).await?;

    Ok(docker)
}

pub async fn close(docker: &Docker) -> Result<(), bollard::errors::Error> {
    let remove_options = Some(RemoveContainerOptions {
        force: true,
        ..Default::default()
    });
    docker.remove_container("regchest", remove_options).await?;

    Ok(())
}

async fn check_regchest_exists(docker: &Docker) -> Result<bool, bollard::errors::Error> {
    let mut list_container_filters = HashMap::new();
    list_container_filters.insert("name", vec!["regchest"]);
    let list_container_options = Some(ListContainersOptions {
        all: true,
        filters: list_container_filters,
        ..Default::default()
    });
    let regchest_exists = if docker.list_containers(list_container_options).await?.len() != 0 {
        true
    } else {
        false
    };

    Ok(regchest_exists)
}

async fn create_regchest_container(docker: &Docker, scenario: &str) -> Result<(), bollard::errors::Error> {
    let container_options = Some(CreateContainerOptions {
        name: "regchest",
        ..Default::default()
    });
    // TODO: Upgrade to published ports. Using host network mode has security concerns due to allowing the container unnecessary privileges. Should currently only be used in cases where the host is not put at risk such as VMs i.e. Github ephemeral runners.
    let host_config = HostConfig {
        network_mode: Some(String::from("host")),
        ..Default::default()
    };
    let container_config = Config {
        image: Some("zingodevops/regchest:005"),
        host_config: Some(host_config),
        cmd: Some(vec![scenario]),
        ..Default::default()
    };
    docker
        .create_container(container_options, container_config)
        .await?;

    Ok(())
}

async fn start_regchest_container(docker: &Docker) -> Result<(), bollard::errors::Error> {
    docker
        .start_container("regchest", None::<StartContainerOptions<String>>)
        .await?;

    Ok(())
}

async fn wait_for_launch(docker: &Docker) -> Result<(), bollard::errors::Error> {
    let logs_options = Some(LogsOptions::<String> {
        stdout: true,
        follow: true,
        ..Default::default()
    });
    let mut stream = docker.logs("regchest", logs_options);
    while let Some(result) = stream.next().await {
        match result {
            Ok(message) => {
                let m = &message.into_bytes();
                let s = std::str::from_utf8(m).unwrap();
                if s.contains("Successfully launched") {
                    break;
                }
            }
            Err(e) => return Err(e),
        }
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn launch_and_check_regchest_exists() {
        let docker = launch(None).await.unwrap();
        assert_eq!(check_regchest_exists(&docker).await.unwrap(), true);
        close(&docker).await.unwrap();
    }
}
