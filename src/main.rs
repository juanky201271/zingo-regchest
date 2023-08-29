// use futures::prelude::*;
use std::{thread, time};
use zingo_testutils::{self, scenarios};

#[tokio::main]
async fn main() {
    let (_regtest_manager, _child_process_handler) =
        scenarios::funded_orchard_mobileclient(1_000_000).await;
    loop {
        thread::sleep(time::Duration::from_millis(100))
    }
}
