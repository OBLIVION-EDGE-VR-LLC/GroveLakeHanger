package com.cias.aircrafthangar;

public enum CraftType {
    TRIANGULAR_BLENDED_WING("Triangular Blended Wing", "Delta-wing stealth fighter"),
    ORB("Orb", "Sphere/ball design"),
    X_WING("X-Wing", "Cross-shaped with 4 wings"),
    CYLINDER_POD("Cylinder/Pod", "Rocket-like tube with fins"),
    SERAPH("Seraph", "Angel/feathered wings"),
    FLYING_WING("Flying Wing", "Pure wings bomber style"),
    FLYING_SAUCER("Flying Saucer", "UFO disc style");

    public final String displayName;
    public final String description;

    CraftType(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }
}
