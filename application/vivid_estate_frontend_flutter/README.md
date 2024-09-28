# Vivid Estate - Flutter Application
This folder contains the source code for the flutter frontend of the Vivid Estate Application. Before compiling into android build apk please update the Server Info in ServerInfo.dart file located in `lib/Authentication/ServerInfo.dart`. Here are the fields to be updated

``` bash
final host = "http://IP:HOST"; // Put your django server ip address and port number
```

## Prerequisites

Before running a Flutter project, ensure that you have the following:

1. **Flutter SDK**:
   - Download and install the Flutter SDK from [Flutter's official website](https://flutter.dev/docs/get-started/install).
   - Follow the installation instructions for your operating system (Windows, macOS, or Linux).
   
2. **Code Editor (IDE)**:
   - Install one of the following IDEs:
     - **Visual Studio Code**: Install the Flutter and Dart extensions.
     - **Android Studio**: Install the Flutter and Dart plugins.

3. **Device/Emulator Setup**:
   - **Physical Device**: 
     - Enable Developer Mode and USB Debugging on your Android device.
     - For iOS, ensure Xcode is installed on macOS and that your device is connected.
   - **Emulator**: Set up an Android or iOS emulator in Android Studio or Xcode.

4. **Install Flutter Dependencies**:
   - This command checks if Flutter, Dart, and other essential tools are correctly installed:
     ```bash
     flutter doctor
     ```

## How to Run and Compile
1. Install Dependencies:
   - Navigate to the project directory and install dependencies by running:
   - ```bash
     flutter pub get
     ```
2. Run the Application by command and select device: ``` flutter run ```
3. Build Android APK: ``` flutter build apk ```
