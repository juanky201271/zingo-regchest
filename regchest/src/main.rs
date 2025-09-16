//use std::{thread, time};
use zingolib::testutils::scenarios;

#[tokio::main]
async fn main() {
    #[cfg(feature = "funded_orchard_sapling_transparent_shielded_mobileclient")]
    let _local_net =
        scenarios::funded_orchard_sapling_transparent_shielded_mobileclient(1_000_000).await;

    #[cfg(feature = "funded_orchard_with_3_txs_mobileclient")]
    let _local_net =
        scenarios::funded_orchard_with_3_txs_mobileclient(1_000_000).await;

    #[cfg(feature = "funded_transparent_mobileclient")]
    let _local_net =
        scenarios::funded_transparent_mobileclient(1_000_000).await;

    #[cfg(feature = "funded_orchard_mobileclient")]
    let _local_net =
        scenarios::funded_orchard_mobileclient(1_000_000).await;
    println!("Successfully launched regchest!");

    //loop {
    //    match local_net.validator_mut().process().try_wait()? {
    //        Ok(Some(status)) => {
    //            println!("Validator Zcashd exited with status: {}", status);
    //            break;
    //        }
    //        Ok(None) => {
    //            // Process has not exited yet
    //        }
    //        Err(e) => {
    //            println!("Error while waiting for validator Zcashd: {:?}", e);
    //            break;
    //        }
    //    }
    //    match local_net.indexer_mut().process().try_wait()? {
    //        Ok(Some(status)) => {
    //            println!("Indexer Lightwalletd exited with status: {}", status);
    //            break;
    //        }
    //        Ok(None) => {
    //            // Process has not exited yet
    //        }
    //        Err(e) => {
    //            println!("Error while waiting for indexer Lightwalletd: {:?}", e);
    //            break;
    //        }
    //    }
    //    thread::sleep(time::Duration::from_millis(100))
    //}
}
