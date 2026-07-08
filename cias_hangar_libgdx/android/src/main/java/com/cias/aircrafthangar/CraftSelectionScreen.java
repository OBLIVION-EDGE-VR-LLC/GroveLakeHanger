package com.cias.aircrafthangar;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Screen;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.PerspectiveCamera;
import com.badlogic.gdx.graphics.g3d.ModelBatch;
import com.badlogic.gdx.graphics.g3d.ModelInstance;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.input.GestureDetector;
import com.badlogic.gdx.math.Vector3;

public class CraftSelectionScreen implements Screen {
    private CiasAircraftHangarGame game;
    private ModelBatch modelBatch;
    private PerspectiveCamera camera;
    private ShapeRenderer shapeRenderer;

    private ModelInstance[] craftModels;
    private CraftType[] craftTypes;
    private int selectedCraftIndex = 0;
    private float rotationY = 0;

    private GestureDetector gestureDetector;
    private float tapTime = 0;
    private boolean craftSelected = false;

    public CraftSelectionScreen(CiasAircraftHangarGame game) {
        this.game = game;
        this.modelBatch = new ModelBatch();
        this.shapeRenderer = new ShapeRenderer();

        setupCamera();
        loadCrafts();

        gestureDetector = new GestureDetector(new GestureDetector.GestureListener() {
            @Override
            public boolean touchDown(float x, float y, int pointer, int button) {
                return false;
            }

            @Override
            public boolean tap(float x, float y, int count, int button) {
                if (count >= 2) {
                    craftSelected = true;
                    return true;
                }
                return false;
            }

            @Override
            public boolean longPress(float x, float y) {
                return false;
            }

            @Override
            public boolean fling(float velocityX, float velocityY, int button) {
                if (velocityX < -100) {
                    selectedCraftIndex = (selectedCraftIndex + 1) % craftTypes.length;
                } else if (velocityX > 100) {
                    selectedCraftIndex = (selectedCraftIndex - 1 + craftTypes.length) % craftTypes.length;
                }
                return true;
            }

            @Override
            public boolean pan(float x, float y, float deltaX, float deltaY) {
                return false;
            }

            @Override
            public boolean panStop(float x, float y, int pointer, int button) {
                return false;
            }

            @Override
            public boolean zoom(float initialDistance, float distance) {
                return false;
            }

            @Override
            public boolean pinch(float initialDistance, float distance, com.badlogic.gdx.math.Vector2 initialPointer1, com.badlogic.gdx.math.Vector2 initialPointer2) {
                return false;
            }

            @Override
            public void pinchStop() {
            }
        });

        Gdx.input.setInputProcessor(gestureDetector);
    }

    private void setupCamera() {
        camera = new PerspectiveCamera(67, Gdx.graphics.getWidth(), Gdx.graphics.getHeight());
        camera.position.set(0, 2, 5);
        camera.lookAt(0, 1.5f, 0);
        camera.update();
    }

    private void loadCrafts() {
        craftTypes = CraftType.values();
        craftModels = new ModelInstance[craftTypes.length];

        for (int i = 0; i < craftTypes.length; i++) {
            craftModels[i] = CraftModel.createCraft(craftTypes[i]);
        }
    }

    @Override
    public void show() {
    }

    @Override
    public void render(float delta) {
        Gdx.gl.glClearColor(0.1f, 0.1f, 0.2f, 1f);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT | GL20.GL_DEPTH_BUFFER_BIT);

        rotationY += 30 * delta;

        // Render 3D model
        camera.update();
        modelBatch.begin(camera);

        ModelInstance currentCraft = craftModels[selectedCraftIndex];
        currentCraft.transform.setToTranslation(0, 1.5f, 0);
        currentCraft.transform.rotate(0, 1, 0, rotationY);

        modelBatch.render(currentCraft, game.getEnvironment());
        modelBatch.end();

        // Draw craft info and controls
        Gdx.app.log("CraftSelection", "Selected: " + craftTypes[selectedCraftIndex].displayName);

        // Check if craft was selected
        if (craftSelected) {
            Gdx.app.log("CraftSelection", "Craft selected: " + craftTypes[selectedCraftIndex].displayName);
            game.startGame(craftTypes[selectedCraftIndex]);
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
