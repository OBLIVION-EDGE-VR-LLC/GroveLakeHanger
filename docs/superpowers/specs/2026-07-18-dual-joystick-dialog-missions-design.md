# Dual Joystick Controls, Dialog System, Craft Variants & Mission Test Scripts — Design Spec

**Date:** 2026-07-18
**Project:** Oblivion Edge / CIA's Aircraft Hangar (Flutter + Three.js WebView)
**Status:** Design Approved

---

## Overview

Add dual on-screen joysticks, an in-flight dialog/storyline system, visually distinct UAP craft with origin backstories, and ADB-driven mission test scripts to the Three.js flight simulator (`flight_sim.html`). Scoped to the Grove Lake tutorial arc (Patriot path intro, 3 missions).

**Approach:** Canvas-drawn joysticks + DOM dialog overlays (Approach A). All new functionality lives inside `flight_sim.html`. No Flutter-side changes required for controls or dialog.

---

## 1. Dual Joystick Controls

### Layout

- **Left joystick** (bottom-left quadrant): Controls **steering** — pitch (up/down) and roll (left/right). Forward = pitch nose down, back = pitch up. Left/right = roll. Displacement distance from center = input intensity (analog).
- **Right joystick** (bottom-right quadrant): Controls **thrust vector + amount**. Vertical axis = throttle (up = more thrust, down = less). Horizontal axis = yaw (left/right rotation). Distance from center = thrust magnitude.

### Visual Design

- Outer ring: 120px diameter, semi-transparent cyan (`#00CED1` at 30% opacity) with 2px border
- Inner knob: 40px diameter, gold (`#FFD700` at 60% opacity)
- Dead zone: 15% of radius — prevents drift from accidental touches
- Labels: "STEER" under left, "THRUST" under right, matching HUD monospace font
- Knob snaps back to center on touch release (short ease-out animation)

### Rendering

- Separate 2D canvas layered over the Three.js canvas (`z-index: 10`, `pointer-events: none` on non-touch areas)
- Touch regions: left half of screen = left joystick, right half = right joystick
- Multi-touch supported — both joysticks simultaneously via `touches` array
- Redrawn each frame only when touch state changes

### Physics Mapping

- Left stick X → `rollRate` (replaces A/D keys)
- Left stick Y → `pitchRate` (replaces W/S keys)
- Right stick Y → `throttle` (replaces Q/E keys, analog 0-1)
- Right stick X → `yawRate` (new axis — currently no yaw control exists)
- Existing keyboard controls remain functional alongside joysticks
- Dead zone: 15% of joystick radius — inputs below this threshold are zeroed

### Input Processing

```
normalizedX = (touchX - centerX) / radius
normalizedY = (touchY - centerY) / radius
magnitude = sqrt(normalizedX^2 + normalizedY^2)
if (magnitude < deadZone) { normalizedX = 0; normalizedY = 0 }
if (magnitude > 1.0) { normalize to unit circle }
```

---

## 2. Dialog & Storyline System

Three dialog modes, all inside `flight_sim.html`:

### Mode 1: Checkpoint Pause Dialog

- **Trigger:** Mission script hits a story beat (e.g., "reached waypoint alpha")
- **Behavior:** Physics loop pauses, joysticks disabled, full-width overlay appears
- **Visual:** Dark semi-transparent backdrop (80% black), centered story panel with cyan border, gold character name header, white body text with typewriter animation (~30ms per character)
- **Controls:** "CONTINUE" button at bottom; tap anywhere to skip typewriter and show full text; second tap advances
- **Use case:** Major plot moments — handler recruitment, mission briefing, discovery reveals

### Mode 2: In-Flight Radio Comms

- **Trigger:** Timer-based or position-based during flight
- **Behavior:** Physics continues running, joysticks stay active — player keeps flying
- **Visual:** Bottom-center HUD bar (replaces pitch/roll display temporarily), styled as radio transmission — character name in gold, message in cyan, slight static/scan-line CSS effect, auto-dismisses after 5 seconds or on tap
- **Queue:** Messages queue up — next one appears 1.5s after previous dismisses
- **Use case:** Radio chatter, handler instructions, atmospheric flavor text, tech backstory tidbits

### Mode 3: Mission Objective Banner

- **Trigger:** New objective assigned
- **Behavior:** Slides in from top, stays for 4 seconds, slides out
- **Visual:** Full-width gold border bar, objective text in white, small objective icon
- **Use case:** "Fly to waypoint ALPHA", "Maintain altitude above 50m", "Land at the airstrip"

### Story Script Format

```javascript
const missionScript = {
  craft: 'sentinel_orb',
  checkpoints: [
    { trigger: 'start', character: 'HANDLER', text: '...', type: 'pause' },
    { trigger: 'altitude>50', character: 'COMMAND', text: '...', type: 'radio' },
    { trigger: 'waypoint_alpha', text: 'Navigate to waypoint BRAVO', type: 'objective' },
  ]
};
```

**Trigger types evaluated each frame:**
- `start` — fires once at mission load
- `altitude>N` / `altitude<N` — altitude threshold
- `speed>N` — speed threshold
- `waypoint_X` — player within 20m of named waypoint
- `time>N` — seconds elapsed since mission start
- `health<N` — health threshold
- `mission_end` — all objectives complete

Each trigger fires only once (tracked in a `firedTriggers` set).

---

## 3. Craft Variants (UAP Visual Diversity)

### Mission 1 — "Sentinel Orb" (existing)

**Geometry:** Current icosahedron sphere + torus ring + 6 spherical pod thrusters. No changes needed.

**Origin Backstory (delivered via radio comms during flight):**

> *"The Sentinel program started in '58 — Lockheed's Skunk Works couldn't figure out why the sphere kept outperforming conventional airframes in wind tunnel tests. Turns out, when you engineer a metamaterial skin with variable dielectric properties, drag becomes... optional. The hull is a nickel-titanium shape-memory alloy — it deforms under stress and reforms perfectly. No rivets, no seams, no radar return. The Air Force wanted wings. The physics wanted a sphere."*

**Tech highlights for radio chatter:**
- Shape-memory alloy hull (NiTi — real material, speculative application)
- Metamaterial skin with tunable EM properties — absorbs radar across X-band and Ku-band
- Omnidirectional thrust via internal reaction mass system (no external nozzles = no IR signature)
- "Faraday cage cockpit" — pilot shielded from craft's own EM emissions

---

### Mission 2 — "Manta Ray" (blended wing body)

**Geometry:**
- **Fuselage:** Flattened `ExtrudeGeometry` from a custom wing-shaped `Shape` — wide delta planform, thin profile, swept leading edges curving smoothly into body
- **Wings:** Integrated into body (one continuous surface — blended wing body, no separate wing pieces)
- **Tail:** Slight upward crank at trailing edge (two small vertical stabilizer fins via `BoxGeometry`)
- **Thrusters:** Two recessed engine glows on rear underside (point lights + flat disc geometry, no spheres)
- **Color:** Dark gunmetal (`#2C3E50`) with cyan edge lighting, subtle panel line texture via emissive stripes
- **Feel:** Stealthy, organic, fast — like a stingray gliding through air

**Origin Backstory (checkpoint dialog before mission):**

> *"You're flying the XR-7 Manta. Northrop started the blended wing body concept in the '40s with the YB-49 — but this? This is something else. The skin is a ceramic matrix composite — silicon carbide fibers in a borosilicate glass matrix. Manufactured in microgravity aboard a classified orbital platform. You can't forge this material on Earth — the crystal structure only forms in freefall. It's transparent to radar, sheds IR like water off a duck, and survives Mach 8 thermal loads. The leading edge runs a plasma actuator array — ionizes the air ahead of the wing, kills turbulence before it forms. No control surfaces. The airflow itself is the control surface."*

**Tech highlights for radio chatter:**
- Ceramic matrix composite (CMC) — real material class, used in jet engine turbine blades today
- Microgravity manufacturing — real NASA research area
- Plasma actuators for flow control — real research, speculative at this scale
- IR suppression: exhaust mixed with ambient air through micro-channels — "thermal diffusion grid"
- Radar cloaking: frequency-selective surface (FSS) skin — passes certain wavelengths, reflects others away from source
- No moving control surfaces — attitude controlled by asymmetric plasma discharge

---

### Mission 3 — "Phantom Lozenge" (pill/tic-tac)

**Geometry:**
- **Body:** `CapsuleGeometry` (cylinder with hemispherical ends) — elongated horizontally, ~3:1 aspect ratio
- **Surface:** Chrome-like material (`metalness: 0.95, roughness: 0.05`), near mirror-finish — classic "tic-tac" UAP look
- **No visible thrusters:** Engine glow from entire underside (large area light beneath hull, pulsing with throttle)
- **Ring:** Single thin equatorial ring (torus, gold) rotating faster with speed
- **Antenna:** Small forward-facing spike geometry (cone) for beacon detection in mission 3
- **Color:** Bright white/silver (`#E8E8E8`) with warm gold ring, eerie blue underglow
- **Feel:** Alien, smooth, unsettling — no obvious means of propulsion

**Origin Backstory (handler reveals during recruitment checkpoint):**

> *"What you're about to fly doesn't have a designation. Not officially. The program that built it was so classified that the engineers who designed it thought they were working on three separate projects. Hull is a bismuth-magnesium layered composite — 26 alternating layers, each thinner than a human hair. Nobody knows exactly why it works. The best theory? The layered structure creates a waveguide effect — electromagnetic energy doesn't bounce off, it gets trapped between layers and re-emitted out the opposite side. Radar looks right through it. IR looks right through it. Visual spectrum? Depends on the angle — sometimes it shimmers, sometimes it's just... not there. Propulsion is... look, I don't fully understand it myself. There's no combustion. No propellant. The underside generates a localized field gradient — the craft doesn't fly through the air, it moves the air out of its way. That's above your clearance. Just fly the thing."*

**Tech highlights for radio chatter:**
- Bismuth-magnesium layered metamaterial — inspired by publicly discussed alleged UAP material samples
- Waveguide cloaking — real physics concept (transformation optics), speculative at macro scale
- 26-layer composite — each layer tuned to absorb successive EM bands (VHF, UHF, S-band, X-band, Ka-band, IR, visible)
- References real patents filed by Salvatore Pais (US Navy) for "inertial mass reduction device"
- Hull manufactured via molecular beam epitaxy (MBE) — real semiconductor technique, speculative at structural scale
- "The craft doesn't fly — it falls in the direction you point it"

---

### Backstory Integration with Dialog System

| Dialog Mode | Content Type |
|---|---|
| **Checkpoint pause** | Handler delivers full backstory paragraph before first flight in that craft |
| **Radio comms** | Technical tidbits during flight — e.g., *"Notice the hull temperature? The CMC skin keeps it under 200C at this speed."* |
| **Objective banner** | Ties tech to gameplay — e.g., *"PLASMA ACTUATORS ONLINE — Use left stick for attitude control"* |

### Implementation

- Each craft defined as a `createCraft_<type>()` function returning a `THREE.Group`
- Mission script specifies which craft to spawn: `missionScript.craft = 'manta_ray'`
- Camera follow logic stays the same (follows group center)
- Physics identical across crafts (same flight model) — visual-only difference for now
- Engine light/particle positions adjusted per craft (array in craft definition)
- HUD "CRAFT" label updates to show craft name

---

## 4. Grove Lake Mission Content (Patriot Path Intro)

### Mission 1: "First Wings"

**Craft:** Sentinel Orb
**Objective:** Learn basic flight controls — take off, fly to altitude, return and hover.

**Story beats:**
- **Checkpoint (start):** *"Welcome to Grove Lake, pilot. I'm your handler — call me Control. Beautiful day for a first flight. Let's see what you've got."*
- **Radio (altitude>30):** *"Good climb. Feel that? That's freedom. Not many people get to see the world from up here."*
- **Objective:** "Reach altitude 100m"
- **Radio (altitude>100):** *"Perfect. Now hold steady — feel the wind, feel the craft respond. You and this machine are one."*
- **Objective:** "Descend to 20m and hover for 5 seconds"
- **Radio (craft backstory, time>30):** *"The Sentinel program started in '58 — Lockheed's Skunk Works couldn't figure out why the sphere kept outperforming conventional airframes..."*
- **Checkpoint (mission_end):** *"Not bad for a first run. You've got instincts, kid. Report back tomorrow — we've got more to show you."*

**Teaching:** Left joystick (pitch/roll), right joystick (throttle), altitude reading.

**Waypoints:** None — altitude-based objectives only.

---

### Mission 2: "Canyon Run"

**Craft:** Manta Ray
**Objective:** Navigate through waypoints along a valley path, practicing steering precision.

**Waypoints:** ALPHA (200, 5, 300), BRAVO (-150, 15, 600), CHARLIE (100, 25, 900) — floating cyan spheres, 20m trigger radius.

**Story beats:**
- **Checkpoint (start):** Manta Ray backstory + *"Morning, pilot. Today we push harder. See those waypoints on your HUD? Follow them through the valley. Precision matters — sloppy flying gets people killed."*
- **Objective:** "Navigate to waypoint ALPHA"
- **Radio (waypoint_alpha):** *"Waypoint ALPHA confirmed. Smooth. Keep that heading."*
- **Objective:** "Navigate to waypoint BRAVO"
- **Radio (waypoint_bravo):** *"BRAVO marked. You're a natural. Command is watching, by the way — don't let that rattle you."*
- **Objective:** "Reach waypoint CHARLIE at speed > 30 m/s"
- **Radio (waypoint_charlie):** *"CHARLIE. Fast and clean. I'm impressed."*
- **Radio (tech tidbit, time>45):** *"Notice how the plasma actuators adjust? No flaps, no ailerons. The air itself bends around you."*
- **Checkpoint (mission_end):** *"Outstanding run. Listen... there's something I need to talk to you about. Not here though. Tomorrow, same time. And pilot? Don't mention this to anyone."*

**Teaching:** Steering precision, yaw control, speed management, waypoint navigation.

---

### Mission 3: "The Recruitment"

**Craft:** Phantom Lozenge
**Objective:** Night flight to a classified waypoint. Handler reveals the bigger picture.

**Environment modification:** Darker skybox (nebula dimmed), ground grid dimmed, fog density increased.

**Waypoints:** CLASSIFIED BEACON (0, 5, 800) — pulsing gold sphere instead of cyan.

**Story beats:**
- **Checkpoint (start):** *"This is off the books. No flight plan, no radio log. Just you and me. There's a beacon 2 klicks north — classified. I need you to fly there and back. Questions later."*
- **Radio (altitude>80):** *"Stay below radar ceiling. Keep it under 100m from here on."*
- **Objective:** "Fly to CLASSIFIED BEACON (stay below 100m)"
- **Radio (time>20):** Phantom Lozenge backstory excerpt — *"The engineers who designed this thing thought they were working on three separate projects..."*
- **Radio (waypoint_beacon):** *"You see it? That facility down there — it doesn't exist. Not on any map. Remember that."*
- **Checkpoint (waypoint_beacon):** *"What you're looking at is bigger than anything you've been told. Your country needs pilots who don't ask questions... but also pilots smart enough to know when to start asking. Which are you?"*
- **Objective:** "Return to Grove Lake airstrip"
- **Checkpoint (mission_end):** *"Welcome to the program, pilot. From here on, everything changes. Get some rest — you'll need it. Area 51 awaits."*

**Teaching:** Altitude discipline (stay below ceiling), night flying confidence, narrative hook into Area 51.

---

## 5. Mission Test Scripts

### File Structure

```
tests/
  mission_common.sh    — shared utilities
  mission_1.sh         — First Wings automated playthrough
  mission_2.sh         — Canyon Run automated playthrough
  mission_3.sh         — The Recruitment automated playthrough
  test_results.log     — output log
```

### Common Utilities (`mission_common.sh`)

```bash
# Core functions:
wait_for_element(text)     # polls adb shell uiautomator dump for text
tap(x, y)                  # adb shell input tap x y
swipe_hold(x1, y1, x2, y2, duration_ms)  # adb shell input swipe
joystick_left(dx, dy, hold_ms)   # swipe from left joystick center
joystick_right(dx, dy, hold_ms)  # swipe from right joystick center
log_result(mission, status, msg) # writes to test_results.log
detect_resolution()        # reads screen res, scales coordinates
```

### ADB Input Mapping (1080x2400 baseline)

| Target | Coordinates | Action |
|---|---|---|
| Left joystick center | (270, 1900) | Steering origin |
| Right joystick center | (810, 1900) | Thrust origin |
| Dialog CONTINUE | (540, 2100) | Tap to advance |
| Pitch up | (270,1900)→(270,1800) | Swipe left stick up |
| Pitch down | (270,1900)→(270,2000) | Swipe left stick down |
| Roll right | (270,1900)→(370,1900) | Swipe left stick right |
| Roll left | (270,1900)→(170,1900) | Swipe left stick left |
| Throttle up | (810,1900)→(810,1750) | Swipe right stick up |
| Throttle down | (810,1900)→(810,2050) | Swipe right stick down |
| Yaw right | (810,1900)→(910,1900) | Swipe right stick right |
| Yaw left | (810,1900)→(710,1900) | Swipe right stick left |

### Mission 1 Script (`mission_1.sh` — First Wings)

1. Launch app, navigate to M1, tap LAUNCH
2. Tap CONTINUE on opening checkpoint dialog
3. Right stick up (throttle) — hold 3 seconds to gain altitude
4. Wait for radio comm at altitude 30m (auto-dismisses)
5. Continue throttle up to reach 100m
6. Wait for objective banner
7. Right stick down (reduce throttle) — descend to 20m
8. Hold hover for 5 seconds
9. Tap CONTINUE on closing checkpoint
10. Verify "MISSION COMPLETE" text visible
11. Log result

### Mission 2 Script (`mission_2.sh` — Canyon Run)

1. Launch app, navigate to M2, tap LAUNCH
2. Tap through opening checkpoint (Manta Ray backstory)
3. Throttle up + pitch forward — fly toward waypoint ALPHA
4. Steer through ALPHA, BRAVO, CHARLIE with combined joystick inputs
5. Tap through radio comms as they appear
6. Tap through closing checkpoint
7. Verify completion

### Mission 3 Script (`mission_3.sh` — The Recruitment)

1. Launch app, navigate to M3, tap LAUNCH
2. Tap through opening checkpoint
3. Throttle up to altitude ~80m (stay below 100m ceiling)
4. Fly north toward beacon waypoint
5. Tap through beacon checkpoint dialog
6. Reverse heading, fly back to start
7. Tap through closing checkpoint
8. Verify completion

### Output Format

```
[2026-07-18 14:30:01] mission_1 PASS — First Wings completed in 45s
[2026-07-18 14:31:15] mission_2 FAIL — Waypoint BRAVO not reached (timeout 60s)
```

---

## 6. Files Modified / Created

### Modified
- `oblivion_edge_flutter/assets/flight_sim.html` — joysticks, dialog system, craft variants, mission scripts, waypoint rendering

### Created
- `tests/mission_common.sh` — shared ADB test utilities
- `tests/mission_1.sh` — First Wings test script
- `tests/mission_2.sh` — Canyon Run test script
- `tests/mission_3.sh` — The Recruitment test script

### Not Modified
- No Flutter/Dart code changes required — all new functionality is inside the HTML/JS flight sim
- `MissionData`, `GameStateModel`, `MissionRunner` unchanged — Grove Lake missions are self-contained in the WebView

---

## 7. Technical Notes

- Waypoints rendered as `IcosahedronGeometry` spheres (radius 2) with emissive cyan material and pulsing animation
- Craft swap happens at mission load — `createCraft_<type>()` replaces the current `craftGroup` children
- Dialog overlay z-index hierarchy: joystick canvas (10) < radio comms (20) < objective banner (30) < checkpoint overlay (40)
- Typewriter effect uses `setInterval` at 30ms per character; clearing interval on tap skips to full text
- Mission script is selected by URL parameter: `flight_sim.html?mission=1` (default: free flight with no script)
- Physics pause during checkpoint: `animate()` skips `updatePhysics()` when `dialogState.paused === true`
- Joystick touch tracking uses `touch.identifier` for multi-touch — each joystick tracks its own touch ID
