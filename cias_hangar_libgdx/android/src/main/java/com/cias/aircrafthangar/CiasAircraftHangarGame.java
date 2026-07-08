package com.cias.aircrafthangar;

import com.badlogic.gdx.Game;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.g3d.Environment;
import com.badlogic.gdx.graphics.g3d.attributes.ColorAttribute;
import com.badlogic.gdx.graphics.g3d.environment.DirectionalLight;
import com.badlogic.gdx.math.Vector3;

public class CiasAircraftHangarGame extends Game {
    public static final String TAG = "CiasAircraftHangar";

    private Environment environment;
    private CraftSelectionScreen craftSelectionScreen;

    @Override
    public void create() {
        Gdx.app.log(TAG, "Game created");

        setupEnvironment();

        // Start with craft selection screen
        craftSelectionScreen = new CraftSelectionScreen(this);
        setScreen(craftSelectionScreen);
    }

    private void setupEnvironment() {
        environment = new Environment();
        environment.set(new ColorAttribute(ColorAttribute.AmbientLight, 0.4f, 0.4f, 0.4f, 1f));

        DirectionalLight light = new DirectionalLight();
        light.set(0.8f, 0.8f, 0.8f, 1f, -1f, -0.8f);
        environment.add(light);
    }

    public Environment getEnvironment() {
        return environment;
    }

    @Override
    public void render() {
        Gdx.gl.glClearColor(0.1f, 0.1f, 0.2f, 1f);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT | GL20.GL_DEPTH_BUFFER_BIT);

        super.render();
    }

    @Override
    public void dispose() {
        super.dispose();
        if (craftSelectionScreen != null) {
            craftSelectionScreen.dispose();
        }
    }

    public void startGame(CraftType craftType) {
        if (craftSelectionScreen != null) {
            craftSelectionScreen.dispose();
        }
        GameScreen gameScreen = new GameScreen(this, craftType);
        setScreen(gameScreen);
    }
}
