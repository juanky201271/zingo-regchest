# Regchest
Regtest zcash/lightwalletd server in a container

## Upload new version to Docker Hub
From the root directory:
 - run 'docker build -t zingodevops/regchest:{new image version number} .' to build the image locally 
 - run 'docker login' and fill in the credentials for DockerHub
 - run 'docker push zingodevops/regchest:{new image version number}' to push to DockerHub

