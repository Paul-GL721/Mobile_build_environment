#Build this image on top of Ubuntu v20.04
FROM ubuntu:20.04

#Build arguments
ARG ANDROID_TOOLS_VERSION=6200805
ARG ANDROID_PLATFORM_VERSION=29
ARG ANDROID_BUILD_TOOLS_VERSION=29.0.3
 
MAINTAINER paul@paulgobero.com

#Change time zone
RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Europe/Dublin /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata
 
#Install curl, git, software-properties-common, python
RUN apt-get update && apt-get install -y software-properties-common curl python git jq

#Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
apt-get install -y nodejs

#Check that node and npm are installed
RUN echo node --version
RUN echo npm -v

#Install cordova and check if available
RUN npm install -g cordova
RUN echo cordova --version

#Install java development kit (jdk-8) 
RUN apt-get update &&  apt-get install -y openjdk-8-jdk wget unzip 

#Set JAVA and ANDROID_HOME environment variables
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
ENV ANDROID_HOME $HOME/Android/Sdk
ENV ANDROID_SDK_ROOT $HOME/Android/Sdk
ENV ANDROID_SDK_FILE_NAME commandlinetools-linux-${ANDROID_TOOLS_VERSION}_latest.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILE_NAME}
ENV ANDROID_SDK ${ANDROID_HOME}
ENV ANDROID_BUILD_TOOLS ${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_BUILD_TOOLS}
ENV GRADLE_HOME $HOME/gradle
#ENV PATH $PATH:$HOME/gradle/gradle-7.5.1/bin

# Install requirements
RUN apt-get -y update && \
    apt-get -y install && \   
    mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget -q ${ANDROID_SDK_URL} && \
    unzip ${ANDROID_SDK_FILE_NAME} && \
    rm ${ANDROID_SDK_FILE_NAME} && \
    yes | sdkmanager --sdk_root=${ANDROID_HOME} "tools" "platforms;android-${ANDROID_PLATFORM_VERSION}" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" 

#Open permissions to android home folder
RUN chmod -R 777 ${ANDROID_SDK_ROOT}

#RUN mkdir -p ${GRADLE_HOME} && apt-get update && \
    #cd ${GRADLE_HOME} && wget -q https://services.gradle.org/distributions/gradle-7.5.1-bin.zip -O gradle-7.5.1-bin.zip && \
    #unzip gradle-7.5.1-bin.zip && \
    #rm gradle-7.5.1-bin.zip

RUN mkdir -p ${GRADLE_HOME} && \
    cd ${GRADLE_HOME} && apt-get update && apt-get -y install gradle
