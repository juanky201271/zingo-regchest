use bollard::container::{
    Config, CreateContainerOptions, LogsOptions, RemoveContainerOptions, StartContainerOptions,
};
use bollard::models::HostConfig;
use bollard::Docker;
use futures::StreamExt;
use std::default::Default;

pub async fn launch() -> Result<Docker, bollard::errors::Error> {
    let docker = Docker::connect_with_local_defaults()?;

    let container_options = Some(CreateContainerOptions {
        name: "regchest",
        ..Default::default()
    });
    let host_config = HostConfig {
        network_mode: Some(String::from("host")),
        ..Default::default()
    };
    let container_config = Config {
        image: Some("zingodevops/regchest:001"),
        host_config: Some(host_config),
        ..Default::default()
    };
    let logs_options = Some(LogsOptions::<String> {
        stdout: true,
        follow: true,
        ..Default::default()
    });

    docker
        .create_container(container_options, container_config)
        .await?;
    docker
        .start_container("regchest", None::<StartContainerOptions<String>>)
        .await?;

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

    Ok(docker)
}

pub async fn close(docker: Docker) {
    let remove_options = Some(RemoveContainerOptions {
        force: true,
        ..Default::default()
    });

    match docker.remove_container("regchest", remove_options).await {
        Ok(_) => println!("Regchest container removed successfully"),
        Err(e) => println!("Failed to remove regchest container: {}", e),
    }
}
