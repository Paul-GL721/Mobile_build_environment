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

#Install java development kit (jdk-11) 
RUN apt-get update &&  apt-get install -y openjdk-11-jdk wget unzip 

#Set JAVA and ANDROID_HOME environment variables
#ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/bin/java
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

#Install android sdk
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O android_tools.zip && \
    unzip android_tools.zip && \
    rm android_tools.zip

#Accept android sdk licences
#RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN yes | tools/bin/sdkmanager --licenses || true

