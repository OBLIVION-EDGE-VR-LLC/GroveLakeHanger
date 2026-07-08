package com.cias.aircrafthangar;

import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.VertexAttributes;
import com.badlogic.gdx.graphics.g3d.Material;
import com.badlogic.gdx.graphics.g3d.Model;
import com.badlogic.gdx.graphics.g3d.ModelInstance;
import com.badlogic.gdx.graphics.g3d.attributes.ColorAttribute;
import com.badlogic.gdx.graphics.g3d.utils.ModelBuilder;
import com.badlogic.gdx.math.Vector3;

public class CraftModel {
    private static final Color NEON_ORANGE = new Color(1f, 0.5f, 0f, 1f);
    private static final Color GLOW_ORANGE = new Color(1f, 0.6f, 0.1f, 1f);

    public static ModelInstance createTriangularBledWing() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;

        // Main fuselage (cone)
        modelBuilder.part("fuselage", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr,
                new Material(ColorAttribute.createDiffuse(NEON_ORANGE)))
                .cone(0.5f, 3f, 0.5f, 16);

        Model model = modelBuilder.end();
        return new ModelInstance(model);
    }

    public static ModelInstance createOrb() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;
        modelBuilder.part("sphere", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr,
                new Material(ColorAttribute.createDiffuse(NEON_ORANGE)))
                .sphere(1f, 1f, 1f, 32, 32);

        Model model = modelBuilder.end();
        return new ModelInstance(model);
    }

    public static ModelInstance createXWing() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;
        Material material = new Material(ColorAttribute.createDiffuse(NEON_ORANGE));

        // Central fuselage (cylinder)
        modelBuilder.part("center", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .cylinder(0.3f, 2f, 0.3f, 16);

        Model model = modelBuilder.end();
        ModelInstance instance = new ModelInstance(model);

        // Create wings as separate instances
        return instance;
    }

    public static ModelInstance createCylinderPod() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;
        Material material = new Material(ColorAttribute.createDiffuse(NEON_ORANGE));

        // Main cylinder body
        modelBuilder.part("body", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .cylinder(0.4f, 3f, 0.4f, 16);

        // Cone nose
        modelBuilder.part("nose", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .cone(0.4f, 0.8f, 0.4f, 16);

        Model model = modelBuilder.end();
        return new ModelInstance(model);
    }

    public static ModelInstance createSeraph() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;
        Material material = new Material(ColorAttribute.createDiffuse(NEON_ORANGE));

        // Main body
        modelBuilder.part("body", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .sphere(0.6f, 0.6f, 0.6f, 24, 24);

        Model model = modelBuilder.end();
        return new ModelInstance(model);
    }

    public static ModelInstance createFlyingWing() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;
        Material material = new Material(ColorAttribute.createDiffuse(NEON_ORANGE));

        // Flat wing body
        modelBuilder.part("body", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .box(4f, 0.3f, 1f);

        Model model = modelBuilder.end();
        return new ModelInstance(model);
    }

    public static ModelInstance createFlyingSaucer() {
        ModelBuilder modelBuilder = new ModelBuilder();
        modelBuilder.begin();

        long attr = VertexAttributes.Usage.Position | VertexAttributes.Usage.Normal;
        Material material = new Material(ColorAttribute.createDiffuse(NEON_ORANGE));

        // Main disc
        modelBuilder.part("disc", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .cylinder(2f, 0.3f, 2f, 24);

        // Dome on top
        modelBuilder.part("dome", com.badlogic.gdx.graphics.GL20.GL_TRIANGLES, attr, material)
                .sphere(0.5f, 0.5f, 0.5f, 16, 16);

        Model model = modelBuilder.end();
        return new ModelInstance(model);
    }

    public static ModelInstance createCraft(CraftType type) {
        switch (type) {
            case TRIANGULAR_BLENDED_WING:
                return createTriangularBledWing();
            case ORB:
                return createOrb();
            case X_WING:
                return createXWing();
            case CYLINDER_POD:
                return createCylinderPod();
            case SERAPH:
                return createSeraph();
            case FLYING_WING:
                return createFlyingWing();
            case FLYING_SAUCER:
                return createFlyingSaucer();
            default:
                return createOrb();
        }
    }
}
