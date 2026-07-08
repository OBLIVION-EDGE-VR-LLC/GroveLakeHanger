# CIA's Aircraft Hangar: Multi-Path Character Story — Design Spec

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

