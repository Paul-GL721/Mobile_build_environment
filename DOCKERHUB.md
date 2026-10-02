# Android Build Environment

**Spend less time configuring build agents and more time building Android apps.**

Managing Android SDKs, Java, and Gradle across automated builds can be time-consuming. This repository provides Docker build images for different Android API levels, with the tools already installed.
Choose the image that matches your project and use it locally, in Jenkins, or in any CICD tool. Build older projects and newer applications without repeatedly reconfiguring your build machine.

**Included:** Android SDK, build tools, Java, Gradle, Node.js, npm, Cordova CLI, and Git.

## Choose an image

Choose a tag matching your project's **compile SDK** and Java requirements.

**Published example for API 34 (Android 14):**

```text
paulgl721/mobile_build_environment:cordovaAPI34-V1.2.99
```

- `cordovaAPI34` means Android API 34.
- `V1.2.99` is the image's build version.

Other tags follow the same pattern:

```text
paulgl721/mobile_build_environment:cordovaAPI<API>-V<VERSION>
```

Browse the [Tags tab](https://hub.docker.com/r/paulgl721/mobile_build_environment/tags) for available versions.

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

Start in a native Android project containing `gradlew`, the Gradle Wrapper script
normally created by Android Studio. You do not install this script separately.

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

`-v "$PWD:/workspace"` connects your current project folder to the container.
`-w /workspace` runs the build there. Your files and APK stay on your computer;
Docker removes the temporary container when the build finishes.

## Jenkins and compatibility

Use a published image tag as a Jenkins Docker agent. Your worker needs Docker and the Docker Pipeline plugin.

- Images target **Linux AMD64**; ARM hosts require emulation.
- The image does not change your project's SDK settings or dependencies.
- Match your project's Gradle, Android Gradle plugin, and Cordova Android versions to the image's tools.
- These images do not include an emulator. Additional SDK packages may require a custom image.
- Keep signing keys and passwords outside images and source control.

[Source, version details, and Jenkins examples](https://github.com/Paul-GL721/Mobile_build_environment)
