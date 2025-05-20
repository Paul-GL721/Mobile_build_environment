# Use Ubuntu 20.04 as base image
FROM ubuntu:20.04

# Build arguments
ARG ANDROID_TOOLS_VERSION=8512546
ARG ANDROID_PLATFORM_VERSION=30
ARG ANDROID_BUILD_TOOLS_VERSION=30.0.3

MAINTAINER paul@paulgobero.com

# Noninteractive for tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone
RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install essential packages
RUN apt-get update && apt-get install -y \
    curl git python3 software-properties-common wget unzip apt-transport-https ca-certificates gnupg lsb-release

# Install Node.js 16 (LTS compatible with Cordova)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Verify node and npm
RUN node --version && npm -v

# Install Cordova CLI
RUN npm install -g cordova

# Verify Cordova version
RUN cordova --version

# Install OpenJDK 11
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_ROOT /opt/android-sdk

# Set correct PATH including sdkmanager
ENV PATH $PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/cmdline-tools/bin

# Install Android SDK command line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd $ANDROID_HOME/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_TOOLS_VERSION}_latest.zip -O tools.zip && \
    unzip tools.zip -d cmdline-tools && \
    rm tools.zip

# Accept licenses and install SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager --sdk_root=${ANDROID_HOME} \
    "platform-tools" \
    "platforms;android-${ANDROID_PLATFORM_VERSION}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "cmdline-tools;latest"

# Install Gradle
RUN apt-get install -y gradle

# Set permissions
RUN chmod -R a+rwX ${ANDROID_HOME}

# Default shell
CMD ["bash"]