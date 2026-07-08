# CIA's Aircraft Hangar - LibGDX Android Game

A complete LibGDX Android game featuring 7 unique aircraft designs with realistic flight physics, mission-based gameplay, and full 3D graphics.

## Project Features

### Aircraft Types
1. **Triangular Blended Wing** - Delta-wing stealth fighter
2. **Orb** - Sphere/ball design
3. **X-Wing** - Cross-shaped with 4 wings
4. **Cylinder/Pod** - Rocket-like tube with fins
5. **Seraph** - Angel/feathered wings
6. **Flying Wing** - Pure wings bomber style
7. **Flying Saucer** - UFO disc style

### Game Mechanics
- Craft Selection Screen
- Flight Physics Engine (gravity, lift, drag, speed calculations)
- Dual-joystick Controls (left: throttle/yaw, right: pitch/roll)
- 8 Mission Types:
  - Patrol
  - Intercept
  - Evasion
  - Precision Landing
  - Endurance
  - Stealth
  - Formation Flying
  - Dogfight
- HUD Display (altitude, speed, throttle, fuel, pitch, roll, yaw)
- Terrain Grid for Movement Feedback
- 3D Camera System

### Visual Features
- Neon Orange Glow Effect on All Craft
- CIA Branding (integrated in design)
- Runway/Hangar Starting Environment
- 3D Terrain Grid
- Real-time 3D Camera Following Craft
- Dynamic Lighting

## Technology Stack

- **LibGDX** 1.12.1 - Game development framework
- **OpenGL ES** - 3D rendering
- **Gradle** - Build system
- **Java 11** - Programming language
- **Android SDK 34** - Target platform

## Requirements

- Java Development Kit (JDK) 11 or later
- Android SDK (API 24 minimum, API 34 target)
- Gradle 7.0+ (or use gradlew)
- Android device or emulator running Android 7.0+ (API 24)

## Project Structure

```
cias_hangar_libgdx/
├── android/
│   ├── src/main/
│   │   ├── java/com/cias/aircrafthangar/
│   │   │   ├── AndroidLauncher.java
│   │   │   ├── CiasAircraftHangarGame.java
│   │   │   ├── CraftModel.java
│   │   │   ├── CraftSelectionScreen.java
│   │   │   ├── CraftType.java
│   │   │   ├── GameScreen.java
│   │   │   ├── InputHandler.java
│   │   │   ├── Mission.java
│   │   │   └── PhysicsEngine.java
│   │   ├── assets/ (game assets)
│   │   └── res/ (Android resources)
│   ├── build.gradle
│   ├── AndroidManifest.xml
│   └── proguard-rules.pro
├── build.gradle
├── settings.gradle
└── gradle.properties
```

## Building the Project

### Prerequisites Setup

1. Install JDK 11+:
   ```bash
   sudo apt-get install openjdk-11-jdk
   ```

2. Install Android SDK (or Android Studio which includes it)

3. Set ANDROID_HOME environment variable:
   ```bash
   export ANDROID_HOME=/path/to/android/sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

### Build APK

1. Navigate to project directory:
   ```bash
   cd /home/bdg/Documents/projects/OBLIVION_EDGE_LLC/ResearchAndDev/Android/cias_hangar_libgdx
   ```

2. Build debug APK:
   ```bash
   ./gradlew assembleDebug
   ```

   Or with wrapper:
   ```bash
   gradle assembleDebug
   ```

3. Build release APK:
   ```bash
   ./gradlew assembleRelease
   ```

### Output APK Location

- Debug APK: `android/build/outputs/apk/debug/android-debug.apk`
- Release APK: `android/build/outputs/apk/release/android-release.apk`

## Installing on Device

### Via ADB (Android Debug Bridge)

1. Connect Android device via USB
2. Enable USB Debugging on device
3. Verify connection:
   ```bash
   adb devices
   ```

4. Install debug APK:
   ```bash
   adb install -r android/build/outputs/apk/debug/android-debug.apk
   ```

### Via USB File Transfer

1. Copy APK to device
2. Use file manager to open and install

## Running the Game

1. Launch "CIA's Aircraft Hangar" from device apps
2. Select a craft by swiping left/right
3. Double-tap to start the game
4. Use dual-joystick controls:
   - **Left Joystick**: Throttle (up/down) and Yaw (left/right)
   - **Right Joystick**: Pitch (up/down) and Roll (left/right)

## Game Controls

- **Left Joystick Area** (bottom-left screen):
  - Vertical: Throttle control (-1 to +1)
  - Horizontal: Yaw/rudder (-1 to +1)

- **Right Joystick Area** (bottom-right screen):
  - Vertical: Pitch/elevator (-1 to +1)
  - Horizontal: Roll/aileron (-1 to +1)

## Physics Engine

The physics engine implements realistic flight dynamics:

- **Gravity**: 9.81 m/s²
- **Air Density**: 1.225 kg/m³
- **Drag Coefficient**: 0.1
- **Lift Coefficient**: 0.5
- **Wing Area**: 10 m²
- **Max Speed**: 300 m/s
- **Mass**: 1000 kg

## Code Organization

### Main Classes

- **AndroidLauncher**: Entry point for Android, initializes LibGDX
- **CiasAircraftHangarGame**: Main game class extending Game
- **CraftSelectionScreen**: UI for selecting aircraft
- **GameScreen**: Main gameplay screen
- **PhysicsEngine**: Flight dynamics calculations
- **InputHandler**: Touch input processing
- **CraftModel**: 3D model generation for all aircraft
- **Mission**: Mission briefing and objectives
- **CraftType**: Enum defining all aircraft types

## Development Notes

### Adding New Craft

1. Add craft type to `CraftType.java` enum
2. Create model builder method in `CraftModel.java`
3. Add case to `createCraft()` switch statement

### Customizing Physics

Edit parameters in `PhysicsEngine.java`:
- Adjust constants at top of class
- Modify force calculation methods

### Adding Missions

1. Add mission type to `Mission.MissionType` enum
2. Add initialization case in `Mission.initializeMission()`

## Troubleshooting

### Gradle Build Issues

- Clear cache: `./gradlew clean`
- Reset daemon: `./gradlew --stop`
- Check Java version: `java -version` (should be 11+)

### Android SDK Issues

- Ensure minimum SDK 24 is installed
- Update Android SDK: `sdkmanager --update`
- Check `local.properties` for SDK path

### Graphics Issues on Emulator

- Use hardware acceleration if available
- Reduce graphics complexity
- Check OpenGL ES 2.0 support

## APK Properties

- **Package Name**: com.cias.aircrafthangar
- **Minimum SDK**: API 24 (Android 7.0)
- **Target SDK**: API 34 (Android 14)
- **Screen Orientation**: Landscape
- **Touch Support**: Multi-touch

## Performance

- Optimized for devices with 1GB+ RAM
- Typical APK size: 10-15 MB
- Recommended screen sizes: 5" - 7" (phones) or larger

## License

Project by OBLIVION_EDGE_LLC - ResearchAndDev Division

## Version

1.0.0 - Initial Release
