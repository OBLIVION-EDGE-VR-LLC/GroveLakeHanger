package com.cias.aircrafthangar;

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.InputProcessor;
import com.badlogic.gdx.input.GestureDetector;

public class InputHandler implements InputProcessor {
    private static final int LEFT_JOYSTICK_AREA_WIDTH = 400;
    private static final int LEFT_JOYSTICK_AREA_HEIGHT = 400;
    private static final int RIGHT_JOYSTICK_AREA_WIDTH = 400;
    private static final int RIGHT_JOYSTICK_AREA_HEIGHT = 400;

    private int screenWidth;
    private int screenHeight;

    // Left joystick: throttle/yaw
    private float leftJoystickX = 0;
    private float leftJoystickY = 0;
    private boolean leftJoystickActive = false;
    private int leftJoystickPointer = -1;

    // Right joystick: pitch/roll
    private float rightJoystickX = 0;
    private float rightJoystickY = 0;
    private boolean rightJoystickActive = false;
    private int rightJoystickPointer = -1;

    private GameScreen gameScreen;

    public InputHandler(GameScreen gameScreen) {
        this.gameScreen = gameScreen;
        this.screenWidth = Gdx.graphics.getWidth();
        this.screenHeight = Gdx.graphics.getHeight();
    }

    @Override
    public boolean touchDown(int screenX, int screenY, int pointer, int button) {
        int invertedY = screenHeight - screenY;

        // Left joystick area (bottom-left)
        if (screenX < LEFT_JOYSTICK_AREA_WIDTH && invertedY < LEFT_JOYSTICK_AREA_HEIGHT) {
            leftJoystickActive = true;
            leftJoystickPointer = pointer;
            updateLeftJoystick(screenX, invertedY);
            return true;
        }

        // Right joystick area (bottom-right)
        if (screenX > screenWidth - RIGHT_JOYSTICK_AREA_WIDTH && invertedY < RIGHT_JOYSTICK_AREA_HEIGHT) {
            rightJoystickActive = true;
            rightJoystickPointer = pointer;
            updateRightJoystick(screenX, invertedY);
            return true;
        }

        return false;
    }

    @Override
    public boolean touchUp(int screenX, int screenY, int pointer, int button) {
        if (pointer == leftJoystickPointer) {
            leftJoystickActive = false;
            leftJoystickPointer = -1;
            leftJoystickX = 0;
            leftJoystickY = 0;
            return true;
        }

        if (pointer == rightJoystickPointer) {
            rightJoystickActive = false;
            rightJoystickPointer = -1;
            rightJoystickX = 0;
            rightJoystickY = 0;
            return true;
        }

        return false;
    }

    @Override
    public boolean touchDragged(int screenX, int screenY, int pointer) {
        int invertedY = screenHeight - screenY;

        if (pointer == leftJoystickPointer) {
            updateLeftJoystick(screenX, invertedY);
            return true;
        }

        if (pointer == rightJoystickPointer) {
            updateRightJoystick(screenX, invertedY);
            return true;
        }

        return false;
    }

    private void updateLeftJoystick(int screenX, int screenY) {
        int centerX = LEFT_JOYSTICK_AREA_WIDTH / 2;
        int centerY = LEFT_JOYSTICK_AREA_HEIGHT / 2;
        float maxDistance = 100f;

        float dx = screenX - centerX;
        float dy = screenY - centerY;
        float distance = (float) Math.sqrt(dx * dx + dy * dy);

        if (distance > maxDistance) {
            distance = maxDistance;
            float angle = (float) Math.atan2(dy, dx);
            dx = (float) Math.cos(angle) * maxDistance;
            dy = (float) Math.sin(angle) * maxDistance;
        }

        leftJoystickX = dx / maxDistance;
        leftJoystickY = dy / maxDistance;
    }

    private void updateRightJoystick(int screenX, int screenY) {
        int centerX = screenWidth - (RIGHT_JOYSTICK_AREA_WIDTH / 2);
        int centerY = RIGHT_JOYSTICK_AREA_HEIGHT / 2;
        float maxDistance = 100f;

        float dx = screenX - centerX;
        float dy = screenY - centerY;
        float distance = (float) Math.sqrt(dx * dx + dy * dy);

        if (distance > maxDistance) {
            distance = maxDistance;
            float angle = (float) Math.atan2(dy, dx);
            dx = (float) Math.cos(angle) * maxDistance;
            dy = (float) Math.sin(angle) * maxDistance;
        }

        rightJoystickX = dx / maxDistance;
        rightJoystickY = dy / maxDistance;
    }

    public float getThrottleInput() {
        return -leftJoystickY;
    }

    public float getYawInput() {
        return leftJoystickX;
    }

    public float getPitchInput() {
        return rightJoystickY;
    }

    public float getRollInput() {
        return rightJoystickX;
    }

    @Override
    public boolean keyDown(int keycode) {
        return false;
    }

    @Override
    public boolean keyUp(int keycode) {
        return false;
    }

    @Override
    public boolean keyTyped(char character) {
        return false;
    }

    @Override
    public boolean mouseMoved(int screenX, int screenY) {
        return false;
    }

    @Override
    public boolean scrolled(float amountX, float amountY) {
        return false;
    }
}
