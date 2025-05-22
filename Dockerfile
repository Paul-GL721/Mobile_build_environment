#Build this image on top of Ubuntu v20.04
FROM ubuntu:20.04

# Build arguments
ARG ANDROID_TOOLS_VERSION=11076708
ARG ANDROID_PLATFORM_VERSION=34
ARG ANDROID_BUILD_TOOLS_VERSION=34.0.0

MAINTAINER paul@paulgobero.com

#Change time zone
RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install base dependencies
RUN apt-get update && apt-get install -y software-properties-common curl python git wget unzip

# Install Node.js 20 (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

#Check that node and npm are installed
RUN echo node --version
RUN echo npm -v

#Install cordova and check if available
RUN npm install -g cordova
RUN echo cordova --version
 
# Install OpenJDK 11 (required for api 30 <= 33)
#RUN apt-get update && apt-get install -y openjdk-11-jdk

# Install OpenJDK 17 (required for Android command line tools >= v11076708)
RUN apt-get update && apt-get install -y openjdk-17-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

#Set JAVA and ANDROID_HOME environment variables
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
ENV ANDROID_HOME $HOME/Android/Sdk
ENV ANDROID_SDK_ROOT $HOME/Android/Sdk
ENV ANDROID_SDK_FILE_NAME commandlinetools-linux-${ANDROID_TOOLS_VERSION}_latest.zip
ENV ANDROID_SDK_URL https://dl.google.com/android/repository/${ANDROID_SDK_FILE_NAME}
ENV ANDROID_SDK ${ANDROID_HOME}
ENV ANDROID_BUILD_TOOLS ${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}
#ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_BUILD_TOOLS}
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VERSION}
ENV GRADLE_HOME $HOME/gradle
#ENV PATH $PATH:$HOME/gradle/gradle-7.5.1/bin

#Install requirements
RUN apt-get -y update && \
    apt-get -y install && \ 
    mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    cd ${ANDROID_HOME}/cmdline-tools && \
    wget -q ${ANDROID_SDK_URL} -O tools.zip && \
    unzip tools.zip -d temp && \
    rm tools.zip && \
    mv temp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest

# Accept licenses and install required components
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses && \
    ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
    "platform-tools" \
    "platforms;android-${ANDROID_PLATFORM_VERSION}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"


#Open permissions to android home folder
RUN chmod -R 777 ${ANDROID_SDK_ROOT}

#Install gradle: 
#RUN mkdir -p ${GRADLE_HOME} && \
    #cd ${GRADLE_HOME} && apt-get update && apt-get -y install gradle

# Gradle 7.6: this is required for android 12 builds
ENV GRADLE_VERSION=7.6
RUN mkdir -p ${GRADLE_HOME} && \
    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -d ${GRADLE_HOME} /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip
ENV PATH="${GRADLE_HOME}/gradle-${GRADLE_VERSION}/bin:${PATH}"