#Build this image on top of Ubuntu v20.04
FROM ubuntu:20.04
 
MAINTAINER paul@paulgobero.com

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Dublin /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
 
#Install curl, git, software-properties-common, python
RUN apt-get update && apt-get install -y software-properties-common curl python git 

#Install nodejs, cordova
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
RUN apt -y install nodejs
RUN npm install -g cordova
