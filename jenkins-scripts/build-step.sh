#!/bin/bash

### CHECK DOCKER VERSIONS ###
docker-compose --version
docker version
echo Builing the docker container...

docker build .