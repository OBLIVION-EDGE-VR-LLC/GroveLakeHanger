# Project Structure - CIA's Aircraft Hangar

Complete file structure and component documentation for the LibGDX Android game project.

## Directory Tree

```
cias_hangar_libgdx/
├── android/                              # Android application module
│   ├── src/
│   │   └── main/
│   │       ├── java/com/cias/aircrafthangar/
│   │       │   ├── AndroidLauncher.java                 # Android entry point
│   │       │   ├── CiasAircraftHangarGame.java         # Main game class
│   │       │   ├── CraftModel.java                      # 3D model factory
│   │       │   ├── CraftSelectionScreen.java            # Craft selection UI
│   │       │   ├── CraftType.java                       # Craft enum
│   │       │   ├── GameScreen.java                      # Main gameplay screen
│   │       │   ├── InputHandler.java                    # Touch input handler
│   │       │   ├── Mission.java                         # Mission system
│   │       │   └── PhysicsEngine.java                   # Flight physics
│   │       ├── assets/                                  # Game assets (empty)
│   │       └── res/
│   │           ├── drawable/
│   │           │   └── ic_launcher.xml                  # App icon
│   │           └── values/
│   │               └── strings.xml                      # String resources
│   ├── build.gradle                     # Android app build configuration
│   ├── AndroidManifest.xml              # Android application manifest
│   └── proguard-rules.pro               # ProGuard minification rules
│
├── gradle/
│   └── wrapper/
│       └── gradle-wrapper.properties     # Gradle wrapper config
│
├── build.gradle                         # Root build configuration
├── settings.gradle                      # Gradle settings and module inclusion
├── gradle.properties                    # Gradle system properties
├── gradlew                              # Gradle wrapper (Linux/Mac)
├── gradlew.bat                          # Gradle wrapper (Windows)
│
├── README.md                            # Main project documentation
├── BUILD.md                             # Detailed build instructions
├── FEATURES.md                          # Complete feature documentation
├── PROJECT_STRUCTURE.md                 # This file
│
├── local.properties.example             # Android SDK path template
└── .gitignore                           # Git ignore rules
```

## File Count Summary

- **Total Files**: 26
- **Java Source Files**: 9
- **Build Configuration Files**: 6
- **Android Resource Files**: 3
- **Documentation Files**: 4
- **Configuration/Other Files**: 4

## File Descriptions

### Core Game Classes (android/src/main/java/com/cias/aircrafthangar/)

#### AndroidLauncher.java
- Entry point for Android application
- Extends AndroidApplication
- Initializes LibGDX configuration
- Sets up display parameters (MSAA, color depth)
- Launches main game instance

#### CiasAircraftHangarGame.java
- Main game class extending Game
- Manages global game state
- Handles screen transitions
- Sets up 3D environment and lighting
- Provides access to environment for all screens

#### CraftType.java
- Enumeration of all 7 aircraft types
- Contains display names and descriptions
- Provides constants for craft identification
- Types: TRIANGULAR_BLENDED_WING, ORB, X_WING, CYLINDER_POD, SERAPH, FLYING_WING, FLYING_SAUCER

#### CraftModel.java
- Factory for 3D aircraft models
- Uses ModelBuilder to create mesh geometry
- All craft use neon orange color (RGB 1.0, 0.5, 0.0)
- Methods: createTriangularBledWing(), createOrb(), createXWing(), etc.
- Geometry types: cones, spheres, cylinders, boxes

#### CraftSelectionScreen.java
- Implements Screen interface
- Displays rotating 3D craft model
- Handles swipe input for craft selection
- Double-tap to select and start game
- Uses GestureDetector for input

#### GameScreen.java
- Main gameplay screen
- Implements flight simulation
- Updates physics each frame
- Manages camera following craft
- Renders terrain grid
- Handles HUD display and game state

#### PhysicsEngine.java
- Flight dynamics calculation
- Implements realistic physics:
  - Gravity (9.81 m/s²)
  - Lift (from airspeed and orientation)
  - Drag (air resistance)
  - Thrust (throttle-controlled)
- Tracks: position, velocity, acceleration, Euler angles
- Fuel consumption system
- Update method called each frame

#### InputHandler.java
- Processes touch input
- Implements InputProcessor interface
- Manages dual joystick input:
  - Left joystick (throttle/yaw)
  - Right joystick (pitch/roll)
- Joystick dead zone and max distance enforcement
- Sends input to PhysicsEngine each frame

#### Mission.java
- Defines mission system
- MissionType enum with 8 mission types:
  1. PATROL - Fly patrol route
  2. INTERCEPT - Reach target
  3. EVASION - Escape to safe zone
  4. PRECISION - Land on airfield
  5. ENDURANCE - Stay airborne
  6. STEALTH - Undetected mission
  7. FORMATION - Fly with wingmen
  8. DOGFIGHT - Engage targets
- Contains mission parameters: target location, time limit, fuel allocation, briefing

### Build Configuration Files

#### build.gradle (Root)
- Gradle version 8.0
- LibGDX version 1.12.1
- Android plugin version 8.0.0
- Repository configuration (Maven Central, Google, Sonatype)
- Dependencies for Android build

#### android/build.gradle
- Android application plugin
- Compile SDK: API 34
- Min SDK: API 24
- Target SDK: API 34
- Java version: 11
- LibGDX dependencies
- ProGuard minification configuration

#### settings.gradle
- Root project name: cias-hangar-libgdx
- Includes :android module

#### gradle.properties
- JVM arguments: -Xmx2048m
- Parallel builds enabled
- Daemon disabled
- AndroidX support enabled

#### gradle/wrapper/gradle-wrapper.properties
- Gradle distribution URL: 8.0
- User home wrapper distribution path

#### gradlew, gradlew.bat
- Gradle wrapper scripts for Linux/Mac and Windows
- Allows building without system gradle installation
- Ensures consistent gradle version

### Android Configuration

#### android/AndroidManifest.xml
- Application name: CIA's Aircraft Hangar
- Package: com.cias.aircrafthangar
- Min SDK: 24 (Android 7.0)
- Target SDK: 34 (Android 14)
- Permissions: INTERNET, ACCESS_NETWORK_STATE
- Screen orientation: Landscape
- Activity: AndroidLauncher
- No title bar, fullscreen mode

#### android/proguard-rules.pro
- LibGDX class preservation
- Game package preservation
- Native method preservation
- View constructor preservation
- Source line number preservation

#### android/src/main/res/values/strings.xml
- Application name resource

#### android/src/main/res/drawable/ic_launcher.xml
- App icon definition (orange square)

### Documentation

#### README.md
- Project overview
- Feature list (7 craft, 8 missions)
- Technology stack
- Requirements
- Project structure
- Build instructions
- Installation guide
- Game controls
- Troubleshooting

#### BUILD.md
- Detailed build setup instructions
- Prerequisites and environment configuration
- Step-by-step build process
- Installation procedures
- Device setup and debugging
- Troubleshooting common issues
- Advanced build options
- CI/CD examples

#### FEATURES.md
- Comprehensive feature documentation
- Aircraft design details
- Physics engine parameters
- Control system explanation
- HUD elements
- Mission descriptions
- Gameplay mechanics
- Visual effects
- Performance characteristics

#### PROJECT_STRUCTURE.md
- This file
- Directory tree
- File descriptions
- Component relationships
- Build process overview

### Configuration Templates

#### local.properties.example
- Template for Android SDK path configuration
- Instructions for Linux/Mac and Windows paths
- Optional NDK and Java Home settings

#### .gitignore
- Gradle build directories
- Android specific files
- IDE configuration
- Editor temporary files
- Debug logs

## Component Relationships

```
AndroidLauncher
    ↓
CiasAircraftHangarGame (extends Game)
    ├─→ CraftSelectionScreen (extends Screen)
    │   ├─→ CraftModel.createCraft()
    │   ├─→ GestureDetector (input)
    │   └─→ Camera + ModelBatch
    │
    └─→ GameScreen (extends Screen)
        ├─→ PhysicsEngine (flight dynamics)
        ├─→ InputHandler (extends InputProcessor)
        ├─→ CraftModel.createCraft()
        ├─→ Mission (mission info)
        ├─→ Camera + ModelBatch
        └─→ ShapeRenderer (terrain grid)
```

## Data Flow

### Game Initialization
1. AndroidLauncher.onCreate()
2. CiasAircraftHangarGame.create()
3. Environment setup
4. CraftSelectionScreen displayed

### Craft Selection Flow
1. CraftSelectionScreen renders
2. User swipes left/right (GestureDetector)
3. selectedCraftIndex updated
4. User double-taps to select
5. GameScreen created with selected CraftType

### Flight Gameplay Flow
1. GameScreen.render() called at 60 FPS
2. InputHandler processes touch input
3. PhysicsEngine.update() calculates forces
4. Camera positioned relative to craft
5. ModelBatch renders craft at new position
6. HUD displays telemetry
7. Collision/game state checks

## Build Process

### Compile Steps
1. Gradle reads settings.gradle
2. Loads build.gradle (root)
3. Loads android/build.gradle
4. Compiles Java source files
5. Links LibGDX dependencies
6. Packages resources
7. Creates DEX files
8. Packages APK

### Output Artifacts
- Debug APK: `android/build/outputs/apk/debug/android-debug.apk`
- Release APK: `android/build/outputs/apk/release/android-release.apk`

## Class Hierarchy

```
Game (LibGDX)
  └─ CiasAircraftHangarGame

Screen (LibGDX)
  ├─ CraftSelectionScreen
  └─ GameScreen

InputProcessor (LibGDX)
  └─ InputHandler

GestureListener (LibGDX)
  └─ CraftSelectionScreen (anonymous inner class)

Enum
  ├─ CraftType
  └─ Mission.MissionType
```

## Key Constants

### Physics (PhysicsEngine.java)
- GRAVITY = 9.81f
- AIR_DENSITY = 1.225f
- DRAG_COEFFICIENT = 0.1f
- LIFT_COEFFICIENT = 0.5f
- WING_AREA = 10f
- MAX_SPEED = 300f
- THROTTLE_RESPONSE = 50f

### Input (InputHandler.java)
- LEFT_JOYSTICK_AREA_WIDTH = 400
- LEFT_JOYSTICK_AREA_HEIGHT = 400
- RIGHT_JOYSTICK_AREA_WIDTH = 400
- RIGHT_JOYSTICK_AREA_HEIGHT = 400

### Graphics (CraftModel.java)
- NEON_ORANGE = Color(1f, 0.5f, 0f, 1f)
- GLOW_ORANGE = Color(1f, 0.6f, 0.1f, 1f)

## Package Structure

```
com.cias.aircrafthangar
├── AndroidLauncher
├── CiasAircraftHangarGame
├── CraftModel
├── CraftSelectionScreen
├── CraftType
├── GameScreen
├── InputHandler
├── Mission
└── PhysicsEngine
```

## Dependencies

### Build Dependencies
- LibGDX 1.12.1
- Android SDK Build Tools 34.x.x
- Android Platform SDK API 34
- Gradle 8.0

### Runtime Dependencies
- LibGDX Core (gdx-1.12.1.jar)
- LibGDX Android Backend (gdx-backend-android-1.12.1.jar)
- Android Framework
- OpenGL ES 2.0

## API Levels

- Minimum SDK: API 24 (Android 7.0 - Nougat)
- Target SDK: API 34 (Android 14)
- Compile SDK: API 34

## Memory and Performance

- Typical APK Size: 10-15 MB
- Recommended RAM: 2GB+
- Minimum RAM: 1GB
- Target FPS: 60
- Screen Orientation: Landscape only

## Future Extension Points

1. **Additional Missions**: Add to Mission.MissionType enum
2. **More Aircraft**: Add to CraftType enum and CraftModel factory
3. **Multiplayer**: Extend GameScreen with network code
4. **Achievements**: Add to game state tracking
5. **Audio**: Implement sound effects and music
6. **Leaderboards**: Add score persistence
7. **Settings**: Create SettingsScreen class
8. **Tutorials**: Add TutorialScreen class

## Configuration Files Priority

1. local.properties (local Android SDK path)
2. gradle.properties (system properties)
3. gradle/wrapper/gradle-wrapper.properties (wrapper config)
4. build.gradle (dependency versions)
5. android/build.gradle (app-specific config)
6. AndroidManifest.xml (Android app manifest)

## Quality Assurance

### Code Standards
- Package: com.cias.aircrafthangar
- Java version: 11
- ProGuard minification: enabled in release
- Code organization: logical class structure

### Testing Framework Ready
- JUnit compatible
- Can add tests in android/src/test/
- Instrumentation tests in android/src/androidTest/

### Documentation Coverage
- 4 markdown documentation files
- Inline code comments
- Feature documentation
- Build instructions
- Project structure guide

---

**Version**: 1.0.0
**Created**: 2026-07-08
**Target Platform**: Android 7.0+ (API 24)
**Build System**: Gradle 8.0
**Game Framework**: LibGDX 1.12.1
