package com.cias.aircrafthangar;

import com.badlogic.gdx.math.Vector3;

public class PhysicsEngine {
    private static final float GRAVITY = 9.81f;
    private static final float AIR_DENSITY = 1.225f;
    private static final float DRAG_COEFFICIENT = 0.1f;
    private static final float LIFT_COEFFICIENT = 0.5f;
    private static final float WING_AREA = 10f;
    private static final float MAX_SPEED = 300f;
    private static final float THROTTLE_RESPONSE = 50f;

    private Vector3 position;
    private Vector3 velocity;
    private Vector3 acceleration;

    private float pitch = 0f;
    private float roll = 0f;
    private float yaw = 0f;

    private float throttle = 0f;
    private float fuel = 100f;
    private float mass = 1000f;

    private Vector3 forward;
    private Vector3 right;
    private Vector3 up;

    public PhysicsEngine() {
        this.position = new Vector3(0, 2, 0);
        this.velocity = new Vector3(0, 0, 0);
        this.acceleration = new Vector3(0, 0, 0);

        this.forward = new Vector3(0, 0, -1);
        this.right = new Vector3(1, 0, 0);
        this.up = new Vector3(0, 1, 0);
    }

    public void update(float deltaTime, float pitchInput, float rollInput, float yawInput, float throttleInput) {
        // Update control inputs
        updatePitch(pitchInput);
        updateRoll(rollInput);
        updateYaw(yawInput);
        updateThrottle(throttleInput);

        // Update orientation vectors based on Euler angles
        updateOrientationVectors();

        // Calculate forces
        Vector3 thrustForce = calculateThrustForce();
        Vector3 dragForce = calculateDragForce();
        Vector3 liftForce = calculateLiftForce();
        Vector3 gravityForce = calculateGravityForce();

        // Sum forces
        acceleration.set(0, 0, 0);
        acceleration.add(thrustForce);
        acceleration.add(dragForce);
        acceleration.add(liftForce);
        acceleration.add(gravityForce);

        // Normalize acceleration by mass
        acceleration.scl(1f / mass);

        // Update velocity
        velocity.add(acceleration.cpy().scl(deltaTime));

        // Limit max speed
        if (velocity.len() > MAX_SPEED) {
            velocity.nor().scl(MAX_SPEED);
        }

        // Update position
        position.add(velocity.cpy().scl(deltaTime));

        // Consume fuel
        if (throttle > 0.1f && fuel > 0) {
            fuel -= throttle * 0.1f * deltaTime;
        }

        // Clamp fuel
        if (fuel < 0) {
            fuel = 0;
            throttle = 0;
        }
    }

    private void updatePitch(float input) {
        pitch += input * 2f;
        pitch = Math.max(-89f, Math.min(89f, pitch));
    }

    private void updateRoll(float input) {
        roll += input * 2f;
        roll = Math.max(-180f, Math.min(180f, roll));
    }

    private void updateYaw(float input) {
        yaw += input * 1f;
        if (yaw > 360f) yaw -= 360f;
        if (yaw < 0f) yaw += 360f;
    }

    private void updateThrottle(float input) {
        throttle += input * THROTTLE_RESPONSE * 0.01f;
        throttle = Math.max(0f, Math.min(1f, throttle));
    }

    private void updateOrientationVectors() {
        float pitchRad = (float) Math.toRadians(pitch);
        float rollRad = (float) Math.toRadians(roll);
        float yawRad = (float) Math.toRadians(yaw);

        float cosPitch = (float) Math.cos(pitchRad);
        float sinPitch = (float) Math.sin(pitchRad);
        float cosRoll = (float) Math.cos(rollRad);
        float sinRoll = (float) Math.sin(rollRad);
        float cosYaw = (float) Math.cos(yawRad);
        float sinYaw = (float) Math.sin(yawRad);

        // Calculate forward vector
        forward.x = sinYaw * cosPitch;
        forward.y = -sinPitch;
        forward.z = -cosYaw * cosPitch;

        // Calculate right vector
        right.x = cosYaw;
        right.y = 0;
        right.z = sinYaw;

        // Calculate up vector (cross product of right and forward)
        up.set(right).crs(forward).nor();
    }

    private Vector3 calculateThrustForce() {
        Vector3 thrust = forward.cpy().scl(throttle * 500f);
        return thrust;
    }

    private Vector3 calculateDragForce() {
        float dragMagnitude = 0.5f * AIR_DENSITY * DRAG_COEFFICIENT * WING_AREA * velocity.len2();
        Vector3 drag = velocity.cpy().nor().scl(-dragMagnitude);
        return drag;
    }

    private Vector3 calculateLiftForce() {
        // Lift depends on velocity and angle of attack
        float speedSquared = velocity.len2();
        float liftMagnitude = 0.5f * AIR_DENSITY * LIFT_COEFFICIENT * WING_AREA * speedSquared;

        // Up vector provides lift
        Vector3 lift = up.cpy().scl(Math.max(0, liftMagnitude));
        return lift;
    }

    private Vector3 calculateGravityForce() {
        return new Vector3(0, -GRAVITY * mass, 0);
    }

    public Vector3 getPosition() {
        return position;
    }

    public Vector3 getVelocity() {
        return velocity;
    }

    public Vector3 getForward() {
        return forward;
    }

    public Vector3 getRight() {
        return right;
    }

    public Vector3 getUp() {
        return up;
    }

    public float getPitch() {
        return pitch;
    }

    public float getRoll() {
        return roll;
    }

    public float getYaw() {
        return yaw;
    }

    public float getThrottle() {
        return throttle;
    }

    public float getFuel() {
        return fuel;
    }

    public float getSpeed() {
        return velocity.len();
    }

    public float getAltitude() {
        return position.y;
    }
}
