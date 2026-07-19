import '../../models/mission_data.dart';

/// The "Silent Wings" Manta Ray ISR mission.
/// Mid-game ISR/SIGINT mission operating a BWB drone with moral choice point.
class MantaRayIsr {
  static final MissionData mission = MissionData(
    id: 'manta_ray_isr',
    name: 'Silent Wings',
    description:
        'Operate a BWB Manta Ray drone for combined ISR: SLAM mapping then SIGINT interception over a classified facility',
    difficulty: 'medium',
    pathAffinity: ['patriot', 'grey', 'hacker'],
    storyAct: 'isr_sigint',
    skillRequirements: {'pilot': 3, 'sigint': 1},
    reward: 1200,
    phases: [
      MissionPhase(
        id: 'slam_pass',
        name: 'SLAM Mapping Pass',
        briefing:
            'We need terrain data on a facility in the valley. You\'ll operate the Manta Ray remotely from the ground station. Its blended wing body gives it the radar cross-section of a bird \u2014 they won\'t see it. Run the SLAM pass at 200m AGL, let the stereoscopic cameras build the map. Don\'t deviate from the flight path.',
        character: 'Handler',
        objective:
            'Guide the Manta Ray through waypoints to SLAM-map the target area',
        educationalContent: [
          'SLAM (Simultaneous Localization and Mapping) builds 3D maps in real-time without GPS, using camera and sensor fusion',
          'Stereoscopic vision uses two cameras offset like human eyes to calculate depth from parallax',
          'Point clouds are 3D datasets where each point represents a measured surface location',
          'A BWB (Blended Wing Body) has no distinct fuselage \u2014 the body blends into the wing, reducing drag and radar cross-section',
        ],
      ),
      MissionPhase(
        id: 'sigint_pass',
        name: 'SIGINT Collection Pass',
        briefing:
            'Second pass. Fly low and slow \u2014 the Manta Ray\'s wing loading of 20.5 g/dm\u00b2 makes it stable at low speeds. The Pi 5 payload will intercept signals across the target area. Watch the signal strength meter and hold your position over active emitters.',
        character: 'Handler',
        objective:
            'Fly the Manta Ray over the target to intercept radio signals with the Pi 5 payload',
        educationalContent: [
          'Radio signals occupy frequency bands: VHF (30-300 MHz) for voice, UHF (300 MHz-3 GHz) for data and military comms',
          'SIGINT operations distinguish between COMINT (intercepted communications) and ELINT (electronic emissions like radar)',
          'Antenna gain patterns determine which direction a receiver is most sensitive \u2014 the Manta Ray\'s belly-mounted antenna covers the ground below',
          'Wing loading of 20.5 g/dm\u00b2 means the drone flies slowly and stably \u2014 ideal for sensor platforms that need time on target',
        ],
      ),
    ],
    choicePoints: [
      ChoicePoint(
        id: 'what_did_you_see',
        triggerAfterPhase: 'slam_pass',
        prompt:
            'The SLAM data shows a hospital 200m from the military comms array. Handler asks for the SIGINT pass. How do you proceed?',
        options: [
          ChoiceOption(
            id: 'military_only',
            label: 'Military frequencies only',
            description:
                'Restrict the Pi 5 payload to known military bands. Clean intel, no civilian data. Handler is satisfied but notes you got "less than we hoped."',
            consequences: ChoiceConsequence(
              reputationChanges: {'patriot': 2},
              handlerTrustDelta: 1,
              narrativeFlag: 'military_only',
            ),
          ),
          ChoiceOption(
            id: 'full_sweep',
            label: 'Full spectrum sweep',
            description:
                'Capture everything \u2014 military and civilian comms. Hospital staff, patients\' calls, everything. Handler: "Now that\'s operational thinking."',
            consequences: ChoiceConsequence(
              reputationChanges: {'grey': 3},
              handlerTrustDelta: -1,
              narrativeFlag: 'full_sweep',
            ),
          ),
          ChoiceOption(
            id: 'flag_hospital',
            label: 'Flag the hospital and request guidance',
            description:
                'Report the civilian presence and ask for updated ROE. Handler: "I gave you your orders." Mission continues military-only, but you\'ve flagged yourself as someone who questions.',
            consequences: ChoiceConsequence(
              reputationChanges: {'grey': 2, 'hacker': 1},
              handlerTrustDelta: -2,
              unlocksMissions: ['grey_followup_recon'],
              narrativeFlag: 'flagged_hospital',
            ),
          ),
        ],
      ),
    ],
    educationalFacts: [
      'The Manta Ray BWB has a 1829mm (6 ft) wingspan with 8.5 ft\u00b2 wing area and aspect ratio of 4.2',
      'All-up weight of 1613g (3.6 lb) with a 10" pusher propeller for quiet rear-mounted propulsion',
      'Payload bay carries a Raspberry Pi 5, ADBS receiver, and battery for autonomous ISR operations',
      'Elevon control surfaces on each wing combine elevator and aileron functions \u2014 standard for flying wings',
      'Real SIGINT analysts process raw intercepts through multiple stages: collection, processing, analysis, and dissemination',
    ],
  );
}
