# Build Instructions for CIA's Aircraft Hangar

This document provides detailed steps to build the CIA's Aircraft Hangar Android game from source.

## Prerequisites

### Required Software

1. **Java Development Kit (JDK)**
   - Version: 11 or later
   - Download: https://www.oracle.com/java/technologies/downloads/
   - Or use OpenJDK: `sudo apt-get install openjdk-11-jdk`
   - Verify: `java -version`

2. **Android SDK**
   - Option A: Install Android Studio (includes SDK)
     - Download: https://developer.android.com/studio
   - Option B: Install Command Line Tools only
     - Download: https://developer.android.com/studio#command-tools

3. **Git** (for version control)
   - Linux: `sudo apt-get install git`
   - macOS: `brew install git`
   - Windows: Download from https://git-scm.com/download/win

### Environment Setup

#### Linux/macOS

1. Set Android SDK path:
   ```bash
   export ANDROID_HOME=~/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

2. Add to your shell config (~/.bashrc, ~/.zshrc, etc.):
   ```bash
   echo 'export ANDROID_HOME=~/Android/Sdk' >> ~/.bashrc
   echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools' >> ~/.bashrc
   source ~/.bashrc
   ```

#### Windows

1. Set ANDROID_HOME environment variable:
   - Right-click "This PC" or "My Computer" → Properties
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Click "New..." under System variables
   - Variable name: `ANDROID_HOME`
   - Variable value: `C:\Users\YourUsername\AppData\Local\Android\Sdk`

2. Add to PATH:
   - In Environment Variables, select `Path` → Click "Edit"
   - Add: `%ANDROID_HOME%\tools`
   - Add: `%ANDROID_HOME%\platform-tools`

### Verify Environment

```bash
# Check Java
java -version
javac -version

# Check Android SDK
adb version
```

## Configuration

### 1. Create local.properties

Copy and edit the example file:

```bash
cp local.properties.example local.properties
```

Edit `local.properties` with your Android SDK path:

**Linux/macOS:**
```properties
sdk.dir=/home/username/Android/Sdk
```

**Windows:**
```properties
sdk.dir=C:\\Users\\username\\AppData\\Local\\Android\\Sdk
```

### 2. Install Required Android Components

Using Android Studio:
1. Open Android Studio
2. Go to Tools → SDK Manager
3. Install:
   - Android SDK Platform API 34
   - Android SDK Platform API 24 (minimum)
   - Android SDK Build-tools 34.x.x
   - Android Emulator (optional)

Using command line:
```bash
sdkmanager "platforms;android-34" "platforms;android-24"
sdkmanager "build-tools;34.0.0"
sdkmanager "emulator" "platform-tools"
```

## Building the Project

### Quick Start

Navigate to project root and build:

```bash
cd /home/bdg/Documents/projects/OBLIVION_EDGE_LLC/ResearchAndDev/Android/cias_hangar_libgdx

# Build debug APK (faster, for testing)
./gradlew assembleDebug

# Or on Windows:
gradlew.bat assembleDebug
```

### Build Options

#### Debug Build (Development)
```bash
./gradlew assembleDebug
```
- Includes debug symbols
- Smaller optimization
- Faster build
- Can be debugged
- Output: `android/build/outputs/apk/debug/android-debug.apk`

#### Release Build (Production)
```bash
./gradlew assembleRelease
```
- Optimized for size
- ProGuard minification applied
- No debug symbols
- Smaller file size
- Output: `android/build/outputs/apk/release/android-release.apk`

#### Clean Build
```bash
./gradlew clean assembleDebug
```
- Removes all build artifacts
- Rebuilds from scratch
- Use if encountering build issues

#### Build with Logging
```bash
./gradlew --info assembleDebug
./gradlew --debug assembleDebug
```

### Build Output

After successful build, the APK will be located at:

**Debug APK:**
```
android/build/outputs/apk/debug/android-debug.apk
```

**Release APK:**
```
android/build/outputs/apk/release/android-release.apk
```

Check file details:
```bash
ls -lh android/build/outputs/apk/debug/android-debug.apk
```

## Installation and Testing

### Connect Android Device

1. Enable USB Debugging:
   - Settings → About phone → Build number (tap 7 times)
   - Settings → Developer Options → USB Debugging (enable)
   - Connect via USB cable

2. Verify connection:
   ```bash
   adb devices
   ```

### Install APK

```bash
# Install debug APK
adb install -r android/build/outputs/apk/debug/android-debug.apk

# Uninstall (if needed)
adb uninstall com.cias.aircrafthangar
```

### Run on Emulator

1. Create virtual device (if needed):
   ```bash
   avdmanager create avd -n CIA_Emulator -k "system-images;android-34;default;x86_64"
   ```

2. Start emulator:
   ```bash
   emulator -avd CIA_Emulator &
   ```

3. Install APK:
   ```bash
   adb install android/build/outputs/apk/debug/android-debug.apk
   ```

### Launch App

- Method 1: Tap app icon on device
- Method 2: Use adb:
  ```bash
  adb shell am start -n com.cias.aircrafthangar/.AndroidLauncher
  ```

### View Logs

```bash
# Real-time log output
adb logcat | grep "CiasAircraftHangar"

# Or filter by tag
adb logcat | grep -i "aircrafthangar"
```

## Troubleshooting

### Gradle Build Issues

#### "ANDROID_HOME is not set"
```bash
# Verify ANDROID_HOME
echo $ANDROID_HOME

# Or set temporarily
export ANDROID_HOME=/path/to/sdk
./gradlew assembleDebug
```

#### "SDK not found"
```bash
# Check installed platforms
sdkmanager --list_installed

# Install missing platform
sdkmanager "platforms;android-34" "build-tools;34.0.0"
```

#### "Gradle daemon crash"
```bash
./gradlew --stop
./gradlew clean assembleDebug
```

#### Build timeout
```bash
# Increase gradle memory
export GRADLE_OPTS="-Xmx2048m"
./gradlew assembleDebug
```

### Compilation Errors

#### "Java version mismatch"
```bash
# Check Java version
java -version

# Should be 11 or later. If not, install Java 11
sudo apt-get install openjdk-11-jdk-headless
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
```

#### "LibGDX dependencies not found"
```bash
# Clear gradle cache
rm -rf ~/.gradle
./gradlew build --refresh-dependencies
```

### Device/Emulator Issues

#### "Device not recognized"
```bash
# Restart adb
adb kill-server
adb start-server
adb devices
```

#### "Permission denied"
```bash
# On Linux, add user to adb group
sudo usermod -a -G plugdev $USER
# Log out and log back in for changes to take effect
```

#### "APK not installing"
```bash
# Uninstall old version first
adb uninstall com.cias.aircrafthangar

# Install with verbose output
adb install -v android/build/outputs/apk/debug/android-debug.apk
```

## Advanced Build Options

### Build for Specific Density

```bash
# Create split APK for specific screen densities
./gradlew assembleDebug --build-cache
```

### Enable Native Debugging

```bash
# Build with debug symbols
./gradlew assembleDebug -x lint
```

### View Gradle Tasks

```bash
./gradlew tasks
```

### Build Dependency Report

```bash
./gradlew dependencies
```

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/build.yml`:

```yaml
name: Build APK

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK 11
        uses: actions/setup-java@v2
        with:
          java-version: '11'
      - name: Grant execute permission
        run: chmod +x gradlew
      - name: Build with Gradle
        run: ./gradlew build assembleDebug
```

## Performance Optimization

### Faster Builds

1. **Enable Gradle Parallel Builds:**
   ```bash
   ./gradlew --parallel assembleDebug
   ```

2. **Use Gradle Daemon:**
   - Already enabled by default
   - Persists JVM between builds

3. **Offline Mode:**
   ```bash
   ./gradlew --offline assembleDebug
   ```

### Reducing APK Size

1. **Enable Minification:**
   - Edit `android/build.gradle`
   - Set `minifyEnabled true` in release build

2. **Enable Resource Shrinking:**
   - Add `shrinkResources true` in release build

## Additional Resources

- LibGDX Documentation: https://libgdx.com/wiki/start/a-new-project
- Android Build Documentation: https://developer.android.com/build
- Gradle Documentation: https://docs.gradle.org/
- Android SDK Setup: https://developer.android.com/studio/install

## Support

For issues or questions:
1. Check the README.md
2. Review build logs: `./gradlew --info assembleDebug`
3. Consult Android documentation
4. Check LibGDX community forums
