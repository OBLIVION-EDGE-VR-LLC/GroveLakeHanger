# Quick Start Guide - CIA's Aircraft Hangar

Get up and running with the game in 5 minutes.

## Prerequisites

- Java Development Kit 11+ (`java -version`)
- Android SDK (via Android Studio or command-line tools)
- ANDROID_HOME environment variable set

## Setup (5 minutes)

### 1. Configure Android SDK Path (1 min)

```bash
cd /home/bdg/Documents/projects/OBLIVION_EDGE_LLC/ResearchAndDev/Android/cias_hangar_libgdx
cp local.properties.example local.properties
```

Edit `local.properties` with your Android SDK path:
```properties
sdk.dir=/path/to/android/sdk
```

### 2. Build APK (2-3 min)

```bash
./gradlew assembleDebug
```

On Windows:
```cmd
gradlew.bat assembleDebug
```

### 3. Install on Device (1-2 min)

```bash
adb install -r android/build/outputs/apk/debug/android-debug.apk
```

### 4. Run the Game

Tap the app icon on your device or use:
```bash
adb shell am start -n com.cias.aircrafthangar/.AndroidLauncher
```

## Game Controls

**Left Joystick** (bottom-left):
- Up/Down: Throttle
- Left/Right: Yaw (turn)

**Right Joystick** (bottom-right):
- Up/Down: Pitch (nose up/down)
- Left/Right: Roll (bank)

## Common Commands

```bash
# Clean build
./gradlew clean assembleDebug

# Install and run
adb install -r android/build/outputs/apk/debug/android-debug.apk
adb shell am start -n com.cias.aircrafthangar/.AndroidLauncher

# View logs
adb logcat | grep "CiasAircraftHangar"

# Uninstall app
adb uninstall com.cias.aircrafthangar

# Reset gradle
./gradlew --stop
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "ANDROID_HOME not set" | Set environment variable: `export ANDROID_HOME=/path/to/sdk` |
| "Build fails" | Run `./gradlew clean` first |
| "Device not found" | Run `adb kill-server` then `adb start-server` |
| "Java version error" | Ensure Java 11+: `java -version` |

## Documentation

- **README.md** - Full project documentation
- **BUILD.md** - Detailed build instructions
- **FEATURES.md** - Complete feature guide
- **PROJECT_STRUCTURE.md** - Project organization

## Next Steps

1. Explore the code in `android/src/main/java/com/cias/aircrafthangar/`
2. Try different aircraft in the selection screen
3. Complete all 8 missions
4. Customize the physics in `PhysicsEngine.java`
5. Add new missions in `Mission.java`

## Support

For detailed help:
1. Check BUILD.md for build issues
2. Check FEATURES.md for game mechanics
3. Check PROJECT_STRUCTURE.md for code organization

Happy flying!
