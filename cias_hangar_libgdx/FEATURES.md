# CIA's Aircraft Hangar - Features Documentation

Comprehensive guide to all game features, mechanics, and gameplay systems.

## Game Overview

CIA's Aircraft Hangar is a 3D flight simulation game developed with LibGDX for Android. Players select from 7 unique aircraft designs, complete challenging missions, and experience realistic flight physics and controls.

## Aircraft Designs

### 1. Triangular Blended Wing
- **Classification**: Delta-wing stealth fighter
- **Characteristics**: 
  - Pointed, aerodynamic design
  - High speed capability
  - Reduced radar cross-section profile
  - Ideal for intercept missions
- **Visual**: Cone-shaped fuselage with triangular wing profile
- **Color**: Neon Orange with glow effects

### 2. Orb
- **Classification**: Sphere/ball design
- **Characteristics**:
  - Symmetrical spherical shape
  - Unique aerodynamic properties
  - Challenging to control
  - Good for precision flying
- **Visual**: Perfect sphere with neon orange surface
- **Color**: Neon Orange with glowing sphere effect

### 3. X-Wing
- **Classification**: Cross-shaped with 4 wings
- **Characteristics**:
  - Four-wing configuration
  - Excellent maneuverability
  - Compact design
  - Great for dogfighting
- **Visual**: Central fuselage with 4 wing extensions
- **Color**: Neon Orange with glowing edges

### 4. Cylinder/Pod
- **Classification**: Rocket-like tube with fins
- **Characteristics**:
  - Streamlined cylindrical body
  - Fin-based stabilization
  - Rocket-inspired design
  - High acceleration
- **Visual**: Cylinder body with pointed nose cone and stabilizer fins
- **Color**: Neon Orange with glow

### 5. Seraph
- **Classification**: Angel/feathered wings
- **Characteristics**:
  - Organic, curved design
  - Smooth flight characteristics
  - Balanced performance
  - Graceful aesthetics
- **Visual**: Smooth sphere with feathered wing details
- **Color**: Neon Orange with feathered glow effect

### 6. Flying Wing
- **Classification**: Pure wings bomber style
- **Characteristics**:
  - Flat wing design
  - Minimal fuselage
  - Excellent payload capacity (conceptually)
  - Stable flight platform
- **Visual**: Large flat wing structure with minimal body
- **Color**: Neon Orange with wing glow

### 7. Flying Saucer
- **Classification**: UFO disc style
- **Characteristics**:
  - Iconic disc shape
  - Rotating elements (visual)
  - Low-gravity feel
  - Fun, science-fiction aesthetic
- **Visual**: Flat disc with dome on top
- **Color**: Neon Orange with dome and edge glow

## Flight Physics Engine

### Core Physics Parameters

```
Gravity:           9.81 m/s²
Air Density:       1.225 kg/m³
Drag Coefficient:  0.1
Lift Coefficient:  0.5
Wing Area:         10 m²
Maximum Speed:     300 m/s
Mass:              1000 kg
Throttle Response: 50 m/s per unit
```

### Force Calculations

#### Thrust Force
- Generated from throttle input (0-100%)
- Forward direction relative to aircraft orientation
- Formula: Thrust = throttle × 500 N

#### Drag Force
- Opposes velocity vector
- Speed-dependent: proportional to velocity²
- Formula: Drag = 0.5 × ρ × Cd × A × v²

#### Lift Force
- Perpendicular to velocity (upward in aircraft frame)
- Depends on airspeed and angle of attack
- Formula: Lift = 0.5 × ρ × Cl × A × v²

#### Gravitational Force
- Constant downward acceleration
- Formula: F_gravity = m × g

### Aircraft Dynamics

#### Orientation Control
- **Pitch**: Elevator control (nose up/down)
  - Range: -89° to +89°
  - Rate: 2° per unit input per frame
- **Roll**: Aileron control (banking left/right)
  - Range: -180° to +180°
  - Rate: 2° per unit input per frame
- **Yaw**: Rudder control (rotation in horizontal plane)
  - Rate: 1° per unit input per frame

#### Flight Characteristics
- Realistic gravity effect
- Speed affects lift generation
- Altitude affects available maneuvers
- Fuel consumption based on throttle usage

## Control System

### Dual-Joystick Interface

#### Left Joystick (Bottom-Left Screen Area)
- **Vertical Axis**: Throttle Control
  - Up: Increase throttle (0 to +1)
  - Down: Decrease throttle (-1 to 0)
  - Neutral: Maintain current throttle
- **Horizontal Axis**: Yaw/Rudder
  - Left: Turn left (-1)
  - Right: Turn right (+1)
  - Neutral: No rotation

#### Right Joystick (Bottom-Right Screen Area)
- **Vertical Axis**: Pitch Control (Elevator)
  - Up: Nose up (+1)
  - Down: Nose down (-1)
  - Neutral: Level flight
- **Horizontal Axis**: Roll Control (Aileron)
  - Left: Bank left (-1)
  - Right: Bank right (+1)
  - Neutral: Level wings

### Control Zones
- Each joystick occupies 400×400 pixel area
- Maximum deflection: 100 pixels from center
- Circular deadzone limit enforced
- Smooth analog input supported

## HUD (Heads-Up Display)

Real-time telemetry displayed during flight:

```
Altitude:    Current height in meters
Speed:       Current velocity in m/s
Throttle:    Engine thrust percentage (0-100%)
Fuel:        Remaining fuel quantity
Pitch:       Aircraft nose angle (degrees)
Roll:        Aircraft bank angle (degrees)
Yaw:         Aircraft heading (degrees)
```

### Display Elements
- Real-time updating at 60 FPS
- Color-coded indicators
- Neon orange theme matching aircraft
- Prominent visibility for critical parameters

## Mission System

### Mission Types

#### 1. Patrol
- **Objective**: Fly designated patrol route
- **Target**: Waypoint location
- **Time Limit**: 300 seconds
- **Fuel Allocation**: 100 units
- **Briefing**: Maintain altitude and scan for threats
- **Difficulty**: Medium

#### 2. Intercept
- **Objective**: Reach high-altitude target
- **Target**: Enemy aircraft position
- **Time Limit**: 180 seconds
- **Fuel Allocation**: 80 units
- **Briefing**: Intercept target at coordinates
- **Difficulty**: Hard

#### 3. Evasion
- **Objective**: Escape to safe zone
- **Target**: Opposite corner of map
- **Time Limit**: 240 seconds
- **Fuel Allocation**: 100 units
- **Briefing**: Evade enemy radar and escape
- **Difficulty**: Hard

#### 4. Precision Landing
- **Objective**: Land on designated airfield
- **Target**: Landing zone at sea level
- **Time Limit**: 300 seconds
- **Fuel Allocation**: 85 units
- **Briefing**: Approach speed: 50-80 m/s
- **Difficulty**: Expert

#### 5. Endurance
- **Objective**: Stay airborne as long as possible
- **Target**: Maintain altitude above 10m
- **Time Limit**: 600 seconds
- **Fuel Allocation**: 100 units
- **Briefing**: Maximum endurance flight
- **Difficulty**: Medium

#### 6. Stealth
- **Objective**: Complete mission undetected
- **Target**: Remote location
- **Time Limit**: 240 seconds
- **Fuel Allocation**: 95 units
- **Briefing**: Maintain low profile, avoid detection
- **Difficulty**: Hard

#### 7. Formation
- **Objective**: Maintain formation with wingmen
- **Target**: Fly in structured pattern
- **Time Limit**: 180 seconds
- **Fuel Allocation**: 90 units
- **Briefing**: Maintain formation at specified altitude
- **Difficulty**: Hard

#### 8. Dogfight
- **Objective**: Engage and eliminate targets
- **Target**: Enemy aircraft positions
- **Time Limit**: 300 seconds
- **Fuel Allocation**: 100 units
- **Briefing**: Engage and eliminate all hostile targets
- **Difficulty**: Expert

### Mission Selection Flow
1. Main menu displays 8 available missions
2. Player selects mission from list
3. Briefing screen shows objectives
4. Mission parameters confirm
5. "Start Mission" button initiates gameplay

### Mission Completion Criteria
- Reach target location
- Maintain altitude above crash limit
- Complete within time limit
- Have fuel remaining
- Successfully execute landing (landing missions)

## Game Environment

### Starting Location
- Hangar/Runway environment
- Flat terrain at sea level
- Ground reference grid (10m spacing)
- Sky dome with gradient coloring

### Terrain System
- Infinite flat plane at y=0
- Visual grid overlay for depth perception
- Ground collision detection
- Crash mechanic at altitude < 0m

### Camera System

#### Third-Person Following Camera
- Positioned behind and above aircraft
- Follows craft with smooth tracking
- Maintains pilot perspective
- 8m behind, 3m above aircraft
- Dynamically updates based on aircraft orientation

#### Camera Angles
- Default: Behind and slightly elevated
- Adjusts for pitch and roll
- Maintains stability during maneuvers
- Zooms to maintain craft visibility

## Visual Effects

### Neon Orange Aesthetic
- All aircraft glow with neon orange
- Primary Color: RGB(1.0, 0.5, 0.0)
- Glow Color: RGB(1.0, 0.6, 0.1)
- Consistent throughout game

### Lighting
- Ambient lighting: 40% brightness
- Directional light simulates sun
- Dynamic shadows on terrain
- Realistic material shading

### Visual Indicators
- Orange HUD text
- Grid terrain reference
- Aircraft silhouettes
- Color-coded information

## Performance Features

### Optimization
- Level-of-Detail (LOD) rendering
- Model instancing for efficiency
- GPU-accelerated rendering
- 16-bit depth for performance

### Target Performance
- 60 FPS on modern devices
- Smooth 3D rendering
- Real-time physics updates
- Low latency input response

### Device Compatibility
- Minimum: Android 7.0 (API 24)
- Target: Android 14 (API 34)
- Minimum RAM: 1GB
- Recommended RAM: 2GB+
- OpenGL ES 2.0 support required

## User Interface

### Craft Selection Screen
- 3D model preview rotating
- Swipe to cycle through aircraft
- Double-tap to select
- Craft name and description display

### Game Screen
- Full-screen 3D viewport
- Dual-joystick control overlay
- HUD metrics display
- Mission objective tracking

### Pause Menu
- Pause/Resume functionality
- Mission abort option
- Settings access
- Return to main menu

## Gameplay Mechanics

### Fuel System
- Limited fuel resource
- Depletes with throttle usage
- Display on HUD
- Game over when depleted

### Altitude Tracking
- Real-time altitude measurement
- Displayed on HUD
- Crash detection at altitude < 0
- Critical altitude warnings

### Speed Monitoring
- Velocity magnitude calculation
- Real-time speed display
- Maximum speed enforcement
- Aerodynamic limitations

### State Management
- In-flight state
- Paused state
- Mission complete state
- Game over state

## Advanced Features

### Multiplayer Preparation (Future)
- Architecture supports future networking
- Physics deterministic for sync
- Leaderboard system ready
- Score calculation framework

### Difficulty Scaling (Future)
- Mission difficulty ratings
- Progressive challenge increase
- Adaptive AI opponents (framework)
- Achievement system ready

### Customization Options (Future)
- Aircraft liveries
- Paint schemes
- HUD customization
- Control sensitivity adjustment

## Audio (Framework Ready)
- Engine sound effects (not yet implemented)
- Wind noise simulation (framework)
- UI sound effects (framework)
- Background music system (framework)

## Data Storage (Framework Ready)
- Mission progress saving
- High score tracking
- Settings persistence
- Flight statistics logging

## Accessibility Features

### Control Options
- Touch-based dual joystick (current)
- Future: Hardware controller support
- Future: Gesture controls
- Remappable controls (framework)

### Visual Accessibility
- High contrast neon design
- Clear HUD readability
- Large UI elements
- Color-independent information

### Text Support
- In-game text is clear
- Mission briefings readable
- HUD labels descriptive
- No critical audio-only cues

## Network Features (Framework Ready)

### Leaderboards
- Global score tracking
- Difficulty-based rankings
- Time-based competition
- Achievement badges

### Statistics Tracking
- Mission completion rates
- Best times per mission
- High scores by aircraft
- Playtime analytics

## Conclusion

CIA's Aircraft Hangar combines realistic flight physics with engaging mission-based gameplay. The 7 unique aircraft designs, combined with 8 diverse missions and intuitive dual-joystick controls, provide a comprehensive flight simulation experience suitable for casual to advanced players.

The game's architecture is designed for extensibility, with frameworks ready for multiplayer features, additional missions, and advanced customization options.
