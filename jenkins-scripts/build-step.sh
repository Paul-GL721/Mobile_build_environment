

### CHECK DOCKER VERSIONS ###
#docker-compose --version
#docker version
#echo Builing the docker container...

#Build from the current context
#docker build . -t 570829005182.dkr.ecr.eu-west-1.amazonaws.com/mobile_build_environment:cordovaAPV34-$VERSION

#Push image to ecr repository
#docker push 570829005182.dkr.ecr.eu-west-1.amazonaws.com/mobile_build_environment:cordovaAPV34-$VERSION

#!/bin/bash

#### CHECK VERSIONS OF DOCKER AND COMPOSE ###
docker-compose --version
docker version
echo "Building the docker image"


# Build, tag, and push the image to docker public repository
docker build . -t ${DOCKER_ACCOUNT}/${REMOTE_REPO_NAME}:cordovaAPI$APIVERSION$VERSION 

whoami
echo usr=$USER

# Switch user and login and push image to docker hub 
#(credentials are in the pass credsStore) 
sudo su ubuntu <<HERE
whoami
echo usr=$USER
docker push ${DOCKER_ACCOUNT}/${REMOTE_REPO_NAME}:cordovaAPI$APIVERSION$VERSION
HERE

echo "Docker image pushed successfully to Docker Registry!"