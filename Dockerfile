#Build this image on top of Ubuntu v20.04
FROM ubuntu:20.04
 
MAINTAINER paul@paulgobero.com

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Dublin /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
 
#Install curl, git, software-properties-common, python
RUN apt-get update && apt-get install -y software-properties-common curl python git 

#Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
apt-get install -y nodejs

#Install cordova
RUN npm install -g cordova

#Install java development kit 
RUN apt-get update &&  apt-get install -y openjdk-11-jdk wget unzip

#Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin/java