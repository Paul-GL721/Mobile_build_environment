#Build this image on top of Ubuntu v20.04
FROM ubuntu:20.04
 
MAINTAINER paul@paulgobero.com

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
 
#Install curl, git, software-properties-common, python
RUN apt-get update && apt-get install -y software-properties-common curl python git 

#Install nodejs, cordova
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
RUN apt -y install nodejs
RUN npm install -g cordova
