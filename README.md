# Regchest
Rust-driven zcash/lightwalletd regtest server in a docker container. Developed to reduce variation between systems and to allow hosts that are unable to run lightwalletd/zcashd binaries (i.e. non-linux systems) to have access to local regtest test environments.

Regchest is still in early stages of development and currently only provides a 10-block blockchain and a 1_000_000 zat funded orchard pool with the seed:
"hospital museum valve antique skate museum unfold vocal weird milk scale social vessel identify crowd hospital control album rib bulb path oven civil tank"
This allows for testing basic operations such as syncing and sending but will be expanded in the future to be configurable to allow for a wider range of test scenarios.

## Regchest utils
This repo also includes a seperate rust library which provides functions which allow the docker container to be easily managed with cargo test runners.

## Uploading a new version to Docker Hub
After necessary changes have been made and merged to zingolabs/zingo-regchest on Github, update the Dockerfile to checkout the latest zingolabs/zingo-regchest merge commit. The following pull request to update this Dockerfile should be named with the new image version number (the current version + 1).

Then, from the root directory:
 - run 'docker build -t zingodevops/regchest:{new image version number} .' to build the image locally 
 - run 'docker login' and fill in the credentials for DockerHub
 - run 'docker push zingodevops/regchest:{new image version number}' to push to DockerHub

