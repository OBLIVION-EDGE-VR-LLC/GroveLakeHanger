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
- Right stick X → `yawRate` (new axis — currently# CIA's Aircraft Hangar: Multi-Path Character Story — Design Spec
  NOTE IT IS MADE UP, ITS A FICTITIOUS STORY
  **Date:** 2026-07-08  
  **Project:** CIA's Aircraft Hangar (Godot 4.7 Android Game)  
  **Status:** Design Approved

---

## Overview

A fan-based narrative flight game where the player begins as an ambitious pilot and grows into a multi-disciplinary operative/hacker. The game explores the "grey zone" of CIA operations, Area 51 mythology, and humanity's relationship with the stars. Through branching choices and consequences, players experience one of three distinct campaign paths, each revealing different facets of moral complexity, espionage, and human ingenuity.

**Core Themes:** Ambition → Competence → Moral Complexity → Redemption/Reckoning  
**Educational Goal:** Teach real skills (radio waves, celestial navigation, signal intelligence) through gameplay and story  
**Replayability:** First playthrough follows consequences (Path A: Patriot); unlocked playthroughs explore alternate ideologies (Path B: Grey, Path C: Hacker)

---

## Character Arcs & Campaign Paths

### Path 1: The Patriot (First Playthrough)

**Theme:** Serving your country, but at what cost?

- **Grove Lake (Intro):** "I love flying. I want to serve my country."
    - Tutorial missions teaching basic flight, navigation, landing
    - Serene mountain landscape; player learns the *joy* of flying
    - Earns first wings, gets recruited by mysterious handler

- **Area 51 (Discovery):** "There's a real mission. A real threat."
    - First branching choice: Do you trust this handler? Do you ask questions?
    - Discover there's something classified here; your country *needs* you
    - Commitment escalates

- **ISR/SIGINT Operations (Mid-Game):** "I'm doing important work."
    - Photo reconnaissance over hostile territory
    - Signal intelligence monitoring, learning radio frequencies
    - Skill building: pilot → operational asset
    - Missions escalate: training → real operations → dangerous operations

- **Deep Russia Missions (Moral Crisis):** "Wait... what am I doing?"
    - Orders to fly over sovereign territory
    - Potential collateral damage (civilian infrastructure)
    - Choice points: Follow orders? Disobey? Report what you've seen?
    - Consequences: Some missions lock/unlock based on choices
    - Handler relationship shifts based on obedience

- **LEO/Cusp Missions (Escalation):** "How far does this go?"
    - Advanced orbital surveillance, pushing boundaries
    - Technical challenges: celestial navigation, atmospheric re-entry
    - Questions about the legitimacy of the mission

- **Moon Mission (Finale - Patriot Version):** "What does this mean for humanity?"
    - Cover operation: pose as astronaut, conduct classified mission
    - Surrounded by wonder (the Moon, Earth from space)
    - Reckoning: "I did what I thought was right. But what now?"
    - Ending message: Hope that humanity can do better. Peace, love, prosperity. The stars are calling—will we answer wisely?

---

### Path 2: The Grey (Unlocked After Playthrough 1)

**Theme:** Questioning authority. What if they're lying to us?

- **Grove Lake (Intro - Different Tone):** Same flight tutorial, but subtle hints.
    - Radio chatter hints at things being hidden
    - Player notices inconsistencies in official story

- **Area 51 (Discovery - Questioning):** "What are they really hiding?"
    - Same branching choice, but choosing to *question* or *dig deeper* unlocks this path
    - Handler is evasive; something doesn't add up
    - Area 51 isn't just a military base—there are *secrets*

- **ISR/SIGINT Operations (Intelligence Gathering):** "I'm going to find out the truth."
    - Same missions as Patriot path, but you're also hacking comms
    - Optional: intercept communications not in the briefing
    - Build reputation as someone who bends the rules
    - Missions: Gather intel on what the government is *really* doing

- **Deep Russia Missions (Rule Breaking):** "I'm not just following orders anymore."
    - Same dangerous ops, but you're making independent calls
    - Choice: Do your own intelligence gathering (unauthorized)
    - Consequences: Handler becomes suspicious; you're on thin ice
    - Uncover a truth about Area 51 / classified technology

- **LEO/Cusp Missions (Going Rogue):** "I know too much now."
    - Missions change: now you're retrieving classified data or evading pursuers
    - Hacking becomes primary skill
    - Handler relationship breaks; you have allies in the intelligence community who also question authority

- **Moon Mission (Finale - Grey Version):** "What have I uncovered? What's the cost?"
    - Same astronaut cover, but now you're on your own
    - Infiltrate a classified lunar facility (conspiracy twist)
    - Ending message: The truth is complicated. Power corrupts. But knowing is the first step to change. See the stars—and question what you see.

---

### Path 3: The Hacker (Unlocked After 2 Playthroughs)

**Theme:** Code and systems are more powerful than bullets.

- **Grove Lake (Intro - Technical):** "Flying is just the beginning. Everything is code."
    - Same tutorial, but player is analyzing flight systems, autopilot logic
    - Hacker mindset evident from start

- **Area 51 (Discovery - Systems):** "What systems are they running? Can I get inside?"
    - Branching choice: Volunteer to help with *technical* systems
    - Area 51 becomes a target for cyber-espionage, not just intelligence gathering

- **ISR/SIGINT Operations (Cyber-Focused):** "I can break their systems."
    - Radio missions shift focus: crack encryption, intercept classified signals
    - Some flights are real; others are simulations (you're training in cyberspace)
    - Skill building: pilot → hacker operator
    - Working from ground stations, analyzing code, not just data

- **Deep Russia Missions (Cyber Warfare):** "The real battlefield is digital."
    - Missions split: some traditional flights, some fully cyber-ops
    - Objective: Penetrate Russian military networks, gather SIGINT digitally
    - Consequences: Digital footprints lead back to you; counterintelligence is hunting

- **LEO/Cusp Missions (Mastery):** "I control the satellites. I control the data."
    - Primarily ground-based hacking ops
    - Infiltrating orbital control systems
    - Accessing classified satellite feeds directly (no physical presence needed)
    - Flight skills now auxiliary to hacking prowess

- **Moon Mission (Finale - Hacker Version):** "The future is digital. And I'm shaping it."
    - Astronaut cover is thin; real mission is infiltrating lunar facility AI/systems
    - Culmination: Break into the most classified system on the Moon
    - Ending message: Technology is power. Use it wisely. The stars belong to everyone—not just governments. A new humanity is possible if we code it right.

---

## Mission Structure & Branching

### Anchor Scenes (All Paths)

1. **Grove Lake** - Tutorial + character origin story (all paths)
2. **Area 51** - Discovery moment + first major branching choice (all paths)
3. **ISR/SIGINT Operations** - Mid-game skill building (all paths, different emphasis)
4. **Deep Russia** - Moral complexity + reputation-shaping choices (all paths)
5. **LEO/Cusp** - Advanced technical challenges (all paths, different mechanics)
6. **Moon** - Finale + thematic resolution (path-specific)

### Branching Logic

**Choice Points (Examples):**
- Area 51: "Trust your handler completely" vs. "Question their motives" → Locks/unlocks Grey path
- Deep Russia: "Follow orders exactly" vs. "Make your own call" → Affects reputation, handler trust
- Hacking Opportunity: "Report the security flaw to HQ" vs. "Keep it as leverage" → Grey/Hacker path only
- Ground Agent: "Protect the agent's safety" vs. "Complete the mission at any cost" → Affects future missions and ending tone

**Consequence Tracking:**
- Each choice increments reputation scores: "Patriot," "Grey," "Hacker"
- Reputation unlocks/locks missions
- Handler trust changes tone and mission debriefings
- Late-game missions vary based on accumulated choices

**Mission Availability:**
- Some missions *only* appear on specific paths
- Example: "Hack the comms station" (Hacker path only) vs. "Photograph the facility" (Patriot path)
- Early playthroughs hint at locked content: "You lack the skills for this mission" or "Your handler won't approve"

### Mission Types (Teaching Different Skills)

1. **ISR (Intelligence, Surveillance, Reconnaissance) Flights**
    - Teach: Pilot skills, spatial awareness, pattern recognition
    - Educational: Celestial navigation, satellite orbits, how surveillance actually works
    - Mechanic: Fly specific routes, photograph/scan designated targets, return safely

2. **SIGINT (Signals Intelligence) Operations**
    - Teach: Radio waves, frequency analysis, signal interpretation
    - Educational: Real radio concepts (VHF, UHF, encryption), how monitoring works
    - Mechanic: Lock onto signals, decode/intercept communications, track radio sources

3. **Deep Russia / Hostile Territory Missions**
    - Teach: Risk assessment, moral decision-making, consequence navigation
    - Educational: Geopolitics, international law, what espionage actually entails
    - Mechanic: Avoid detection, manage fuel/time, make in-flight decisions

4. **Astronaut / Orbital Operations**
    - Teach: Orbital mechanics, space systems, working at extreme altitudes
    - Educational: Orbital dynamics, re-entry physics, space terminology
    - Mechanic: Precise maneuvering, system management, mission timing

5. **Hacking / Cyber Operations** (Hacker path primary)
    - Teach: Cybersecurity basics, systems thinking, code fundamentals
    - Educational: Real vulnerabilities, encryption, digital footprints
    - Mechanic: Breach systems, crack codes, infiltrate networks

---

## Skill Progression

### Early Game (Grove Lake → Area 51)
**Focus:** Pilot fundamentals, basic trust-building, learning the landscape

- Flight basics: takeoff, landing, navigation, basic combat evasion
- Story: Learning who to trust; first hint that there's more to this world
- Educational: Basic radio use, reading instruments, celestial navigation intro
- Outcome: "Wings earned" — you're cleared for real operations

### Mid Game (ISR/SIGINT Operations)
**Focus:** Competence building, skill diversification, moral questions beginning

- Pilot skills advancing: precision flying, low-altitude ops, high-speed maneuvers
- New skills: Radio monitoring, signal analysis, photo interpretation
- Hacker path divergence: Basic system access, encryption intro
- Story: Realizing your work has real impact; first moral ambiguities
- Educational: Radio waves deep dive, signal types, how SIGINT works in practice
- Outcome: "Operational asset" — you're trusted with solo missions

### Late Game (Deep Russia / Advanced Ops)
**Focus:** Mastery, specialization by path, moral reckoning

**Patriot:** Advanced flying, combat scenarios, following orders under pressure  
**Grey:** Hacking advanced systems, operating independently, building rogue network  
**Hacker:** Full cyber-penetration, minimal flight time, maximum system control

- Story: Questioning your role; what are the real consequences?
- Educational: Advanced concepts (encryption breaking, orbital mechanics, geopolitical context)
- Outcome: "Master operative" — you're running your own operations (with or without handler approval)

### End Game (LEO/Moon)
**Focus:** Integration of all skills, thematic resolution, transcendence

- All paths: Advanced technical mastery specific to their specialization
- Story: Reckoning with choices made; understanding the bigger picture
- Educational: Orbital mechanics, space systems, Area 51 mythology resolution
- Outcome: Mission success or failure based on player choices and skill development

---

## Environment & Scenes

### Visual Identity (Approach B: 5-6 Key Environments)

1. **Grove Lake (Day, Serene)**
    - Beautiful mountain landscape, crystal lake, clear sky
    - Small airstrip, one hangar, pine trees
    - Tone: Wonder, beauty, potential
    - Reusable for: Training, peaceful interludes

2. **Area 51 (Night, Mysterious)**
    - Desert facility, distant mountains
    - Hangars, radar dishes, underground entrances hinted at
    - Stars overhead; something feels *wrong* about the night sky
    - Tone: Intrigue, unease, secrets
    - Reusable for: Base scenes, briefings, discoveries

3. **Russia Airspace (Hostile)**
    - Industrial landscape, military installations, cities
    - Radar sweeps, searchlights, flak
    - Overcast sky, heavy atmosphere
    - Tone: Danger, moral weight, consequence
    - Reusable for: Dangerous missions, high stakes

4. **Ground Stations / Interior Scenes (Technical)**
    - Radio equipment, computer banks, maps
    - Fluorescent lights, underground bunker aesthetic
    - Multiple locations: Grove Lake base, Area 51, rogue safe house (Grey path)
    - Tone: Operational, clinical, tactical
    - Reusable for: SIGINT ops, hacking scenes, briefings

5. **LEO / Cusp of Space (Transcendent)**
    - Blue Earth below, blackness above, stars
    - Orbital view, satellite structures
    - Serene and terrifying simultaneously
    - Tone: Awe, perspective shift, beautiful danger
    - Reusable for: Advanced missions, space sequence

6. **Moon (Silver, Reflective)**
    - Crater landscape, Earth hanging in black sky
    - Lunar base (hidden CIA facility / conspiracy element)
    - Alien beauty, human presence, isolation
    - Tone: Wonder, reckoning, hope, finality
    - Reusable for: Finale, endgame

---

## Story Beats & Moral Complexity

### The "Grey Zone"

The game explores moral ambiguity through **player agency**:

- **Patriot Path:** Doing *necessary evils* for national security. Consequences: Personal cost, collateral damage, loss of moral clarity.
- **Grey Path:** Questioning *authority itself*. Consequences: Isolation, vulnerability, living with uncertainty.
- **Hacker Path:** Using *power outside the system*. Consequences: Responsibility without oversight, potential for abuse.

No path is "right" or "wrong"—each has costs and truths.

### Area 51 Mythology

The game weaves fact and fiction:

- **Real:** Area 51 is a real classified facility; the government does conduct advanced research there
- **Mythology:** Aliens, UFOs, anti-gravity tech
- **Grey Zone:** What if Area 51's *real* secrets are more interesting than the myths?
    - Advanced aircraft reverse-engineering (real)
    - Black-budget satellites and surveillance (real)
    - Classified AI systems (speculative but plausible)
    - Area 51's role in Cold War espionage (real)

Player discovery: "The real story is about human ingenuity and ambition, not aliens—but that's still incredible."

### Ending Messages (Path-Specific)

**Patriot Ending:**
> "You served your country. You made hard choices for what you believed was right. But the cost was high. As you look at Earth from the Moon, you wonder: was there a better way? The stars are calling us upward. Will the next generation find the wisdom we lacked?"

**Grey Ending:**
> "You questioned authority. You uncovered truths. But you're alone now, knowing things no one else knows. The burden of knowledge is heavy. The stars are watching. What will you do with what you've learned?"

**Hacker Ending:**
> "You rewrote the rules. You wielded power without permission. You changed the game. But power always has a price. The stars are being reprogrammed by humans like you. Will you code a better future?"

**Universal Finale (All Paths Converge):**
> "The future of humanity is not written by governments or hackers or patriots alone. It's written by all of us—with ambition, with ingenuity, with difficult choices. May we see the stars again. May we do better. Peace. Love. Prosperity. The cosmos awaits."

---

## Educational Integration

### CIA Factoids (From cia.gov, Factbook.gov)

Woven into mission briefings, radio traffic, intel reports:

- **Example:** "Intelligence brief: Russia's fighter fleet composition—12,000+ aircraft. Their pilot training program emphasizes low-level flying..."
- **Example:** "Radio intercept: Frequency 254.8 MHz, identified as civilian air traffic control. Note: Civilian and military frequencies sometimes overlap in contested airspace..."
- **Example:** "Area 51 Historical Context: Project U-2 (1955), A-12 OXCART (1962), and countless classified aircraft developments. Why? To understand threats and maintain technological advantage."

### Real Skills Teaching

1. **Radio Waves & Frequency Monitoring (SIGINT Missions)**
    - Concept: Electromagnetic spectrum, frequency ranges (VHF, UHF, microwave)
    - Application: Tuning into radio signals, identifying signal types, basic signal decoding
    - Real-world: How SIGINT actually works; why radio monitoring is crucial to intelligence
    - In-game: SIGINT missions require learning to identify friend/enemy/civilian signals

2. **Celestial Navigation (ISR / Astronaut Missions)**
    - Concept: Using stars and orbital mechanics for navigation
    - Application: Plotting courses using celestial bodies, understanding orbital passes
    - Real-world: How pilots navigate at high altitudes; how satellites maintain orbits
    - In-game: Advanced missions require celestial navigation for precision

3. **Orbital Mechanics (LEO/Moon Missions)**
    - Concept: Gravity, velocity, orbital altitude, re-entry physics
    - Application: Understanding why orbits work; managing fuel and trajectory
    - Real-world: How spacecraft actually operate; constraints of physics
    - In-game: LEO missions teach orbital mechanics through gameplay necessity

4. **Area 51 Mythology (Throughout)**
    - Concept: Debunking vs. reality
    - Application: Missions reveal that human achievement is more remarkable than fiction
    - Real-world: Real classified aircraft programs (U-2, SR-71, stealth technology) are genuinely amazing
    - In-game: Story uncovers "the real Area 51"—black-budget tech, not aliens

### Teaching Through Character Arc

The game teaches through *experience*, not exposition:

- Player learns radio concepts by *using* them in SIGINT missions
- Player learns orbital mechanics by *flying* in LEO
- Player learns about moral complexity by *making* difficult choices
- Player learns about Area 51 history by *uncovering* classified projects

---

## Implementation Approach (B + C Hybrid)

### Phase 1: Patriot Path (Primary Playthrough)
**Goal:** Establish full game loop with branching, skill progression, and story arcs

- Rename project: "Oblivion Edge Flight" → "CIA's Aircraft Hangar"
- Update package name: `com.oblivionedge.flight` → `com.cias.aircrafthangar`
- Build Grove Lake environment and tutorial
- Build Area 51 base environment
- Create ISR/SIGINT mission sequences (5-7 missions teaching pilot + radio skills)
- Create Deep Russia mission sequence (3-4 dangerous, choice-heavy missions)
- Build LEO/Cusp environments and missions
- Create Moon finale (Patriot version)
- Implement mission system with choice tracking and branching logic
- Test full playthrough end-to-end

**Outcome:** Complete Patriot path, playable from start to finish with meaningful choices

### Phase 2: Grey Path (First Unlock)
**Goal:** Build alternate campaign showing consequence of questioning authority

- Rework Area 51 into "discovery" vs. "trust" branching
- Create hacking-light missions (intercepting comms, data theft)
- Build rogue safe house environment (alternative to military base)
- Create Grey-specific Deep Russia missions (operating independently)
- Create Moon finale (Grey version)
- Integrate choice tracking so Patriot path hints at Grey path
- Test full Patriot → Grey unlock flow

**Outcome:** Complete Grey path, unlocked after Patriot playthrough

### Phase 3: Hacker Path (Second Unlock)
**Goal:** Build cyber-focused campaign emphasizing systems and code

- Create cyber-training sequences (hacking basics)
- Build ground station environments for hacking ops
- Rework missions with cyber-focus (parallel to traditional flight ops)
- Create Hacker-specific Deep Russia / LEO missions (minimal flying, max hacking)
- Create Moon finale (Hacker version)
- Integrate choice tracking for Hacker path unlock
- Test full progression: Patriot → Grey → Hacker

**Outcome:** Complete Hacker path, all three campaigns playable, full replayability

---

## Technical Considerations

### Mission System Architecture

- **MissionData:** Extend current mission system to include:
    - `mission_id`: Unique identifier
    - `paths`: Which campaigns include this mission
    - `choice_points`: Decision nodes in the mission
    - `consequences`: How choices affect future missions
    - `skill_requirements`: What skills player needs for this mission

- **ChoiceTracking:** New system to track:
    - Reputation scores (Patriot / Grey / Hacker)
    - Mission history
    - Handler trust level
    - Unlocked/locked missions

- **BranchingLogic:** Mission availability determined by:
    - Current playthrough number
    - Reputation scores
    - Choice history
    - Skill development

### Environment System

- Reusable 3D environment prefabs (Grove Lake, Area 51, Russia, LEO, Moon)
- Scene transitions between missions
- Dynamic UI reflecting mission context (military briefing vs. hacker message board)

### Educational Integration

- Factoid system: Display CIA facts during briefings / intel reports
- Radio mission system: Teach frequency, signal analysis
- Orbital mechanics system: Display trajectory data, orbital parameters

---

## Success Criteria

- [ ] All three campaign paths playable end-to-end
- [ ] Choice consequences visible in mission availability and story outcomes
- [ ] Educational content (radio, celestial navigation, CIA facts) integrated and teachable
- [ ] Character arc progresses distinctly per path (Patriot / Grey / Hacker)
- [ ] Player first playthrough doesn't reveal full branching (hints at locked content)
- [ ] Endings are thematically distinct and meaningful
- [ ] Game teaches real skills while telling compelling story

---

## Scope Notes

- **Exclusions:** Motion capture cinematics, voice acting (UI text only)
- **Potential Expansions (Post-Launch):** Additional paths, more Area 51 lore, multiplayer intel sharing
- **Art Style:** Current stylized Godot aesthetic; environments are mood-focused, not photorealistic

---

## References

- Current mission system: `godot_game/scripts/mission_system.gd`
- Current main scene: `godot_game/scenes/main.tscn`
- Godot 4.7 documentation
- CIA.gov and Factbook resources for factoids
- Area 51 historical research
  no yaw control exists)
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
