#!/usr/bin/env bash
set -euo pipefail

# Google's Linux SDK build-tools contain x86-64 binaries.
test "$(dpkg --print-architecture)" = amd64
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends ca-certificates curl git unzip python3
rm -rf /var/lib/apt/lists/*

ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm
ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx
npm install --global "cordova@${CORDOVA_VERSION}" \
    --fetch-timeout=30000 --fetch-retries=1 --loglevel=http
npm cache clean --force

mkdir -p "${ANDROID_HOME}/cmdline-tools" "${GRADLE_HOME}"
curl --fail --location --retry 3 \
    "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_TOOLS_VERSION}_latest.zip" \
    --output /tmp/android-tools.zip
unzip -q /tmp/android-tools.zip -d "${ANDROID_HOME}/cmdline-tools"
mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest"

# Keep sdkmanager usable with the older application JDKs as well.
cat > /usr/local/bin/sdkmanager <<'EOF'
#!/bin/sh
export JAVA_HOME=/opt/java/sdk
exec "${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager" "$@"
EOF
chmod +x /usr/local/bin/sdkmanager
# yes receives SIGPIPE when sdkmanager finishes; still propagate sdkmanager failures.
set +o pipefail
yes | sdkmanager --sdk_root="${ANDROID_HOME}" --licenses
set -o pipefail
sdkmanager --sdk_root="${ANDROID_HOME}" --channel=0 \
    "platform-tools" \
    "platforms;android-${ANDROID_PLATFORM_VERSION}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

curl --fail --location --retry 3 \
    "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    --output /tmp/gradle.zip
unzip -q /tmp/gradle.zip -d "${GRADLE_HOME}"
rm /tmp/android-tools.zip /tmp/gradle.zip

# Fail the image build if the requested SDK was not installed.
test -f "${ANDROID_HOME}/platforms/android-${ANDROID_PLATFORM_VERSION}/android.jar"
test -x "${ANDROID_BUILD_TOOLS}/aapt2"
java -version
node --version
npm --version
cordova --version
gradle --version

# Build agents may run as the Jenkins host uid rather than root.
chmod -R a+rX "${ANDROID_HOME}" "${GRADLE_HOME}"
