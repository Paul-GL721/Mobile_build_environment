#!/bin/bash

### CHECK DOCKER VERSIONS ###
docker-compose --version
docker version
echo Builing the docker container...

#Build from the current context
docker build . -t 570829005182.dkr.ecr.eu-west-1.amazonaws.com/mobile_build_environment:cordovaAPV32-$VERSION

#Push image to ecr repository
docker push 570829005182.dkr.ecr.eu-west-1.amazonaws.com/mobile_build_environment:cordovaAPV32-$VERSION