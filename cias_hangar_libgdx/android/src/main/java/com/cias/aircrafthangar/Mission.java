package com.cias.aircrafthangar;

import com.badlogic.gdx.math.Vector3;

public class Mission {
    public enum MissionType {
        PATROL("Patrol", "Fly a patrol route and return safely"),
        INTERCEPT("Intercept", "Reach the target location"),
        EVASION("Evasion", "Evade enemy fire and escape"),
        PRECISION("Precision", "Land at the designated airfield"),
        ENDURANCE("Endurance", "Stay airborne for maximum time"),
        STEALTH("Stealth", "Complete mission undetected"),
        FORMATION("Formation", "Fly in formation with wingmen"),
        DOGFIGHT("Dogfight", "Engage and eliminate targets");

        public final String name;
        public final String description;

        MissionType(String name, String description) {
            this.name = name;
            this.description = description;
        }
    }

    private int missionNumber;
    private MissionType type;
    private Vector3 targetLocation;
    private Vector3 startingLocation;
    private float timeLimit;
    private float fuelAllocation;
    private String briefing;

    public Mission(int missionNumber, MissionType type) {
        this.missionNumber = missionNumber;
        this.type = type;
        this.startingLocation = new Vector3(0, 2, 0);

        initializeMission();
    }

    private void initializeMission() {
        switch (type) {
            case PATROL:
                targetLocation = new Vector3(100, 2, 0);
                timeLimit = 300f;
                fuelAllocation = 100f;
                briefing = "Patrol route alpha. Maintain altitude and scan for threats.";
                break;

            case INTERCEPT:
                targetLocation = new Vector3(150, 50, 100);
                timeLimit = 180f;
                fuelAllocation = 80f;
                briefing = "Intercept target at coordinates. Minimum altitude 30m.";
                break;

            case EVASION:
                targetLocation = new Vector3(-100, 100, -150);
                timeLimit = 240f;
                fuelAllocation = 100f;
                briefing = "Evade enemy radar and escape to safe zone.";
                break;

            case PRECISION:
                targetLocation = new Vector3(200, 0, 50);
                timeLimit = 300f;
                fuelAllocation = 85f;
                briefing = "Execute precision landing on airfield. Approach speed: 50-80 m/s";
                break;

            case ENDURANCE:
                targetLocation = new Vector3(50, 50, 50);
                timeLimit = 600f;
                fuelAllocation = 100f;
                briefing = "Maximum endurance flight. Stay aloft as long as possible.";
                break;

            case STEALTH:
                targetLocation = new Vector3(120, 80, -80);
                timeLimit = 240f;
                fuelAllocation = 95f;
                briefing = "Maintain low profile. Avoid radar detection.";
                break;

            case FORMATION:
                targetLocation = new Vector3(100, 50, 0);
                timeLimit = 180f;
                fuelAllocation = 90f;
                briefing = "Maintain formation with wingmen at specified altitude.";
                break;

            case DOGFIGHT:
                targetLocation = new Vector3(80, 100, 60);
                timeLimit = 300f;
                fuelAllocation = 100f;
                briefing = "Engage and eliminate all hostile targets.";
                break;

            default:
                targetLocation = new Vector3(100, 50, 0);
                timeLimit = 300f;
                fuelAllocation = 100f;
                briefing = "Complete objective successfully.";
        }
    }

    public int getMissionNumber() {
        return missionNumber;
    }

    public MissionType getType() {
        return type;
    }

    public Vector3 getTargetLocation() {
        return targetLocation;
    }

    public Vector3 getStartingLocation() {
        return startingLocation;
    }

    public float getTimeLimit() {
        return timeLimit;
    }

    public float getFuelAllocation() {
        return fuelAllocation;
    }

    public String getBriefing() {
        return briefing;
    }

    public String getFullDescription() {
        return "Mission " + missionNumber + ": " + type.name + "\n" + type.description + "\n\n" + briefing;
    }
}
