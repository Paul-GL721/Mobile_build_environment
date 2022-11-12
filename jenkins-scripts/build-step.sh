#!/bin/bash

### CHECK DOCKER VERSIONS ###
docker-compose --version
docker version
echo Builing the docker container...

#Build from the current context
docker build .