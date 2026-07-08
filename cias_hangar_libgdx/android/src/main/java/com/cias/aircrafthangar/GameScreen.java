package com.cias.aircrafthangar;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.PerspectiveCamera;
import com.badlogic.gdx.graphics.g3d.ModelBatch;
import com.badlogic.gdx.graphics.g3d.ModelInstance;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.math.Vector3;

public class GameScreen implements Screen {
    private CiasAircraftHangarGame game;
    private CraftType selectedCraft;

    private ModelBatch modelBatch;
    private PerspectiveCamera camera;
    private ShapeRenderer shapeRenderer;

    private PhysicsEngine physics;
    private InputHandler inputHandler;

    private ModelInstance craftModel;
    private ModelInstance terrainModel;

    private int currentMission = 0;
    private static final int TOTAL_MISSIONS = 8;

    public GameScreen(CiasAircraftHangarGame game, CraftType craftType) {
        this.game = game;
        this.selectedCraft = craftType;

        this.modelBatch = new ModelBatch();
        this.shapeRenderer = new ShapeRenderer();

        setupCamera();
        createTerrain();

        this.physics = new PhysicsEngine();
        this.inputHandler = new InputHandler(this);

        this.craftModel = CraftModel.createCraft(craftType);

        Gdx.input.setInputProcessor(inputHandler);

        Gdx.app.log("GameScreen", "Started mission 1 with craft: " + craftType.displayName);
    }

    private void setupCamera() {
        camera = new PerspectiveCamera(67, Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
        camera.near = 0.1f;
        camera.far = 500f;
        camera.update();
    }

    private void createTerrain() {
        // Terrain is created as part of render (grid)
        // This placeholder for future terrain model implementation
    }

    @Override
    public void show() {
    }

    @Override
    public void render(float delta) {
        Gdx.gl.glClearColor(0.1f, 0.15f, 0.3f, 1f);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT | GL20.GL_DEPTH_BUFFER_BIT);

        // Update physics
        physics.update(delta,
                inputHandler.getPitchInput(),
                inputHandler.getRollInput(),
                inputHandler.getYawInput(),
                inputHandler.getThrottleInput());

        // Update camera to follow craft
        updateCamera();

        // Render 3D scene
        modelBatch.begin(camera);

        // Render craft
        Vector3 pos = physics.getPosition();
        craftModel.transform.setToTranslation(pos);

        Vector3 forward = physics.getForward();
        Vector3 right = physics.getRight();
        Vector3 up = physics.getUp();

        craftModel.transform.set(
                right.x, right.y, right.z, pos.x,
                up.x, up.y, up.z, pos.y,
                -forward.x, -forward.y, -forward.z, pos.z,
                0, 0, 0, 1
        );

        modelBatch.render(craftModel, game.getEnvironment());

        // Render terrain grid
        renderTerrainGrid();

        modelBatch.end();

        // Render HUD
        renderHUD();

        // Handle game over conditions
        checkGameConditions();
    }

    private void updateCamera() {
        Vector3 craftPos = physics.getPosition();
        Vector3 craftForward = physics.getForward();
        Vector3 craftUp = physics.getUp();

        // Camera positioned behind and above craft
        Vector3 cameraOffset = craftForward.cpy().scl(-8).add(craftUp.cpy().scl(3));
        camera.position.set(craftPos).add(cameraOffset);
        camera.up.set(craftUp);
        camera.lookAt(craftPos);
        camera.update();
    }

    private void renderTerrainGrid() {
        // Render a ground grid for reference
        // This is simplified - a full implementation would render an actual terrain mesh
        float gridSize = 200f;
        float gridSpacing = 10f;

        shapeRenderer.setProjectionMatrix(camera.combined);
        shapeRenderer.begin(ShapeRenderer.ShapeType.Line);
        shapeRenderer.setColor(0.5f, 0.5f, 0.5f, 0.5f);

        for (float x = -gridSize; x <= gridSize; x += gridSpacing) {
            shapeRenderer.line(x, 0, -gridSize, x, 0, gridSize);
            shapeRenderer.line(-gridSize, 0, x, gridSize, 0, x);
        }

        shapeRenderer.end();
    }

    private void renderHUD() {
        // HUD rendering would go here
        // For now, just log the telemetry
        Gdx.app.log("HUD", String.format(
                "Alt: %.1f | Spd: %.1f | Thr: %.1f | Fuel: %.1f | Pitch: %.1f | Roll: %.1f | Yaw: %.1f",
                physics.getAltitude(),
                physics.getSpeed(),
                physics.getThrottle() * 100,
                physics.getFuel(),
                physics.getPitch(),
                physics.getRoll(),
                physics.getYaw()
        ));
    }

    private void checkGameConditions() {
        float altitude = physics.getAltitude();
        float fuel = physics.getFuel();

        // Check if crashed (altitude below 0)
        if (altitude < 0) {
            Gdx.app.log("GameScreen", "CRASHED!");
            // Reset or return to menu
        }

        // Check if out of fuel
        if (fuel <= 0 && physics.getThrottle() == 0) {
            Gdx.app.log("GameScreen", "Out of fuel");
        }
    }

    @Override
    public void resize(int width, int height) {
        camera.viewportWidth = width;
        camera.viewportHeight = height;
        camera.update();
    }

    @Override
    public void pause() {
    }

    @Override
    public void resume() {
    }

    @Override
    public void hide() {
    }

    @Override
    public void dispose() {
        modelBatch.dispose();
        shapeRenderer.dispose();
    }
}
