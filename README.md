# Android build images for Jenkins and local development

**Spend less time configuring build agents and more time building Android apps.**

Managing Android SDKs, Java, and Gradle across projects takes time. This repository
provides Docker images for different Android API levels, with the build tools already
installed.

Choose the image that matches your project and use it locally, in Jenkins, or in another
CI/CD system that supports Docker. Build older and newer projects without repeatedly
reconfiguring your build machine.

## Quick start

With Docker running, open a macOS or Linux terminal in your Android project folder. This
example uses the published API 34 image; choose a different tag from [Docker
Hub](https://hub.docker.com/r/paulgl721/mobile_build_environment/tags) if your project
needs another SDK or Java version.

### Native Android project

Run this example from the project folder containing `gradlew`.

```sh
export IMAGE="paulgl721/mobile_build_environment:cordovaAPI34-V1.2.99"
docker pull --platform linux/amd64 "$IMAGE"
docker run --rm --platform linux/amd64 \
  --user "$(id -u):$(id -g)" \
  -e HOME=/workspace \
  -e GRADLE_USER_HOME=/workspace/.gradle \
  -e ANDROID_USER_HOME=/workspace/.android \
  -v "$PWD:/workspace" -w /workspace \
  "$IMAGE" bash ./gradlew --no-daemon assembleDebug
```

Your project and build outputs stay on your machine. The debug APK is typically saved in
`app/build/outputs/apk/debug/`.

### Cordova project

**1. Open your Cordova project folder.** Use the folder containing `config.xml`
and `package.json`. Replace the example path with your project's location:

```sh
cd /path/to/your/cordova-app
```

Your project's dependencies and a compatible `cordova-android` platform must already
be configured. Choose an image that matches that platform's SDK and Java requirements.

**2. Download the image and build your app.** Run these commands in the same terminal:

```sh
export IMAGE="paulgl721/mobile_build_environment:cordovaAPI34-V1.2.99"
docker pull --platform linux/amd64 "$IMAGE"
docker run --rm --platform linux/amd64 \
  --user "$(id -u):$(id -g)" \
  -e HOME=/workspace \
  -e GRADLE_USER_HOME=/workspace/.gradle \
  -e ANDROID_USER_HOME=/workspace/.android \
  -e npm_config_cache=/workspace/.npm \
  -v "$PWD:/workspace" \
  -w /workspace \
  "$IMAGE" cordova build android
```

**How Docker connects to your folder:**

- `$PWD` is your current folder on your computer.
- `-v "$PWD:/workspace"` makes that folder available inside the container as
  `/workspace`. Changes and generated files are saved in your local project.
- `-w /workspace` runs the build from that folder inside the container.
- `cordova build android` builds from the Cordova project root. Use this command
  for Cordova projects instead of the native Android `./gradlew` example above.

**3. Find your APK on your computer.** The debug APK is typically saved at:

```text
platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

Docker removes the temporary container after the build; your project and APK remain.

## How the Dockerfiles work

- Each `Dockerfile-API<N>` installs the corresponding Android SDK platform
  and the tools listed below.
- `Dockerfile-API37` uses the SDK package `platforms;android-37.0`.
- The generic `Dockerfile` defaults to API 34.

Build images from the repository root. All Dockerfiles use the shared installer at
`build-support/install-android.sh`.

### SDK and tool versions

| API  | Android        | Build-tools | Application JDK | Bootstrap Gradle |
| ---- | -------------- | ----------- | --------------- | ---------------- |
| 29   | 10             | 29.0.3      | 8               | 6.5              |
| 30   | 11             | 30.0.3      | 11              | 7.1.1            |
| 31   | 12             | 30.0.3      | 11              | 7.1.1            |
| 32   | 12L            | 32.0.0      | 11              | 7.4.2            |
| 33   | 13             | 33.0.2      | 11              | 7.6              |
| 34   | 14             | 34.0.0      | 17              | 8.7              |
| 35   | 15             | 35.0.0      | 17              | 8.13             |
| 36   | 16             | 36.0.0      | 17              | 8.14.2           |
| 36.1 | 16 (minor SDK) | 36.1.0      | 17              | 8.14.2           |
| 37   | 17 (SDK 37.0)  | 37.0.0      | 17              | 8.14.2           |
| 37.1 | 17 (minor SDK) | 37.0.0      | 17              | 8.14.2           |
| 37.2 | 17 (minor SDK) | 37.0.0      | 17              | 8.14.2           |

[Android 17 is the latest stable major release (API
37)](https://android-developers.googleblog.com/2026/06/Android-17.html), checked
September 30, 2026. The [SDK repository
index](https://dl.google.com/android/repository/repository2-3.xml) also lists stable
minor SDKs through 37.2. Modern command-line tools are required to read those package
entries.

Build-tools versions need not match the platform number: API 31 uses 30.0.3 for
compatibility with older Android Gradle plugins.

All images include Node.js 22, Cordova CLI 12.0.0, Git, Python 3 and Android
command-line tools 15859902. A separate Java 21 installation runs `sdkmanager`, so SDK
management still works when the application requires Java 8 or 11. Builds accept Android
SDK licenses automatically.

## Build an image

```sh
docker build --platform linux/amd64 -f Dockerfile-API29 -t android-build:api29 .
docker build --platform linux/amd64 -f Dockerfile-API37.2 -t android-build:api37.2 .
```

Use Linux amd64 agents (or Docker amd64 emulation), since Google's Linux Android
build-tools contain x86-64 binaries. Versions can be overridden with build arguments,
for example `--build-arg GRADLE_VERSION=8.13`.

The application must configure its own `compileSdk`, `targetSdk`, Android Gradle plugin
and Gradle wrapper. Installing an SDK does not change these settings. Use `./gradlew`
for native Android projects; the installed Gradle also supports Cordova's wrapper
bootstrap.

For Cordova projects, pin `cordova-android` in the application. Its version is separate
from the global Cordova CLI. See the [Cordova compatibility
table](https://cordova.apache.org/docs/en/latest/guide/platforms/android/). That table
currently documents support through API 36; the API 37 image provides the Android SDK
but does not imply Cordova support for API 37. Older Cordova plugins may also require a
different Node.js or application toolchain.

## Jenkins

### Build and publish images

This repository's Jenkinsfile discovers every `Dockerfile-API*` and builds and publishes
them sequentially. Adding another API Dockerfile automatically includes it in the next
run, including minor versions such as 37.2.

Each image is tagged `cordovaAPI<API>-V1.1.<BUILD_NUMBER>` in
`paulgl721/mobile_build_environment`. The pipeline stops if any build or push fails;
images published earlier in that run remain available. Publishing uses the existing
Docker credentials of the worker's `ubuntu` account via `sudo`.

### Use an image as a build agent

In the Android application's Jenkinsfile, use a published image as the agent (replace
the example image with your registry and immutable version tag):

```groovy
pipeline {
    agent {
        docker {
            image 'android-build:api34'
            label 'buildnode'
        }
    }
    stages {
        stage('Build Android') {
            steps {
                sh '''
                    export GRADLE_USER_HOME="$WORKSPACE/.gradle"
                    export ANDROID_USER_HOME="$WORKSPACE/.android"
                    export npm_config_cache="$WORKSPACE/.npm"
                    ./gradlew --no-daemon assembleDebug
                '''
            }
        }
    }
}
```

Jenkins needs the Docker Pipeline plugin and a Docker-capable worker. The SDK is
readable by arbitrary Jenkins user IDs. Install additional SDK packages during image
creation; the running agent should keep caches in writable workspace locations. Cordova
builds can use `cordova build android` with `HOME` set to a writable workspace directory
if the Jenkins user has no home inside the image.
