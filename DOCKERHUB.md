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

**1. Open a terminal** in your Android project folder (macOS or Linux). Docker must be running.

**2. Download the image.** This example uses the published API 34 tag:

```sh
export IMAGE="paulgl721/mobile_build_environment:cordovaAPI34-V1.2.99"
docker pull --platform linux/amd64 "$IMAGE"
```

**3. Build a debug APK** in the same terminal:

```sh
docker run --rm --platform linux/amd64 \
  --user "$(id -u):$(id -g)" \
  -e HOME=/workspace \
  -e GRADLE_USER_HOME=/workspace/.gradle \
  -e ANDROID_USER_HOME=/workspace/.android \
  -v "$PWD:/workspace" -w /workspace \
  "$IMAGE" bash ./gradlew --no-daemon assembleDebug
```

**Find your APK:** typically `app/build/outputs/apk/debug/`.

Your files and build outputs stay in your project folder. The temporary container is removed after the build.

## Jenkins and compatibility

Use a published image tag as a Jenkins Docker agent. Your worker needs Docker and the Docker Pipeline plugin.

- Images target **Linux AMD64**; ARM hosts require emulation.
- The image does not change your project's SDK settings or dependencies.
- Match your project's Gradle, Android Gradle plugin, and Cordova Android versions to the image's tools.
- These images do not include an emulator. Additional SDK packages may require a custom image.
- Keep signing keys and passwords outside images and source control.

[Source, version details, and Jenkins examples](https://github.com/Paul-GL721/Mobile_build_environment)