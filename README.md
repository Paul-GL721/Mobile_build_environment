The main reason it works for API 29 but fails for 30 or 32 is that you're trying to install the "tools" package, which was deprecated and removed in later SDK versions. Starting with command-line tools version 9477386, only cmdline-tools is valid.

The sdkmanager is a command-line tool that lets you view, install, update, and uninstall packages for the Android SDK. If you're using Android Studio, then you don't need to use this tool, and you can instead manage your SDK packages from the IDE.

The sdkmanager tool is provided in the Android SDK Command-Line Tools package. To use the SDK Manager to install a version of the command-line tools, follow these steps:

1. Download the latest command line tools package from the Android Studio page and extract the package.
2. Move the unzipped cmdline-tools directory into a new directory of your choice, such as android_sdk. This new directory is your Android SDK directory.
3. In the unzipped cmdline-tools directory, create a sub-directory called latest.
4. Move the original cmdline-tools directory contents, including the lib directory, bin directory, NOTICE.txt file, and source.properties file, into the newly created latest directory. You can now use the command-line tools from this location.
5. (Optional) To install a previous version of the command-line tools, run the following command:
ref: https://developer.android.com/tools/sdkmanager