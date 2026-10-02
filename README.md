# Android Build Images for Local Development and CI/CD systems

**Spend less time configuring build agents and more time building Android apps.**

Managing Android SDKs, Java, and Gradle across projects takes time. This repository
provides Docker images for different Android API levels, with the build tools already
installed. You can build android applications locally, in Jenkins, or in any CI/CD system that supports Docker.

Choose the image that matches your project. Build older and newer projects without repeatedly
reconfiguring your build machine.

## Quick start

Start Docker and open a macOS or Linux terminal. Choose the section for your project:

| Project type | Start in the folder containing | Build command |
| --- | --- | --- |
| Native Android (for example, Android Studio) | `gradlew` and `settings.gradle` or `settings.gradle.kts` | `bash ./gradlew --no-daemon assembleDebug` |
| Cordova | `config.xml` and `package.json` | `cordova build android` |

Both examples use the published API 34 image. Choose a different
[Docker Hub tag](https://hub.docker.com/r/paulgl721/mobile_build_environment/tags)
if your project requires another Android SDK or Java version.

### Build a native Android app

Use this section for an existing native Android project. `gradlew` is the project's
Gradle Wrapper script, normally created by Android Studio; you do not install it
separately. If your project has no `gradlew`, restore or generate its wrapper before
using this example.

Replace the path below with your project folder, then run:

```sh
cd /path/to/your/android-app
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

**Find your APK:** typically `app/build/outputs/apk/debug/` in your project folder.

### Build a Cordova app

Use this section for an existing Cordova project with its dependencies and a compatible
`cordova-android` platform configured. You do not need `gradlew` in your Cordova root
folder or a separate local installation of Java, Gradle, or the Android SDK.

Replace the path below with the folder containing `config.xml` and `package.json`:

```sh
cd /path/to/your/cordova-app
export IMAGE="paulgl721/mobile_build_environment:cordovaAPI34-V1.2.99"
docker pull --platform linux/amd64 "$IMAGE"
docker run --rm --platform linux/amd64 \
  --user "$(id -u):$(id -g)" \
  -e HOME=/workspace \
  -e GRADLE_USER_HOME=/workspace/.gradle \
  -e ANDROID_USER_HOME=/workspace/.android \
  -e npm_config_cache=/workspace/.npm \
  -v "$PWD:/workspace" -w /workspace \
  "$IMAGE" cordova build android
```

**Find your APK:** typically
`platforms/android/app/build/outputs/apk/debug/app-debug.apk` in your project folder.

### How Docker connects to your folder

- `$PWD` is your current project folder on your computer.
- `-v "$PWD:/workspace"` makes that folder available inside the container as
  `/workspace`. Changes and generated files are saved in your local project.
- `-w /workspace` runs the command from that folder inside the container.
- `--rm` removes the temporary container after the build; your project and APK remain.

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

## Build a custom image (optional)

Skip this section if you are using a published image from Docker Hub. Run these
commands from this repository's root, rather than your application project folder.

```sh
docker build --platform linux/amd64 -f Dockerfile-API29 -t android-build:api29 .
docker build --platform linux/amd64 -f Dockerfile-API37.2 -t android-build:api37.2 .
```

Use Linux amd64 agents (or Docker amd64 emulation), since Google's Linux Android
build-tools contain x86-64 binaries. Versions can be overridden with build arguments,
for example `--build-arg GRADLE_VERSION=8.13`.

Installing an SDK in the image does not change your application's SDK settings or
dependencies. Cordova manages the generated Android project and its Gradle wrapper.

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

In your Cordova application's Jenkinsfile, use a published image as the agent.
This example assumes the project dependencies and Android platform are configured.
Choose an image compatible with your project and replace `buildnode` with your
Docker-capable worker's label:

```groovy
pipeline {
    agent {
        docker {
            image 'paulgl721/mobile_build_environment:cordovaAPI34-V1.2.99'
            args '--platform linux/amd64'
            label 'buildnode'
        }
    }
    stages {
        stage('Build Android') {
            steps {
                sh '''
                    export HOME="$WORKSPACE"
                    export GRADLE_USER_HOME="$WORKSPACE/.gradle"
                    export ANDROID_USER_HOME="$WORKSPACE/.android"
                    export npm_config_cache="$WORKSPACE/.npm"
                    cordova build android
                '''
            }
        }
    }
}
```

For a native Android project, replace `cordova build android` in the example above
with `bash ./gradlew --no-daemon assembleDebug` and check out the folder containing
`gradlew`.

Jenkins needs the Docker Pipeline plugin and a Docker-capable worker. The SDK is
readable by arbitrary Jenkins user IDs. Install additional SDK packages during image
creation; the running agent should keep caches in writable workspace locations, as shown above.
