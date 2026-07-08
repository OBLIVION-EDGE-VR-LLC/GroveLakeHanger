#include "godot_wrapper.h"
#include <android/log.h>
#include <jni.h>

#define LOG_TAG "GodotBridge"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

namespace godot_flutter {

// Static member initialization
bool GodotBridge::initialized_ = false;
JNIEnv* GodotBridge::jni_env_ = nullptr;
jobject GodotBridge::android_context_ = nullptr;

void GodotBridge::init(JNIEnv* env, jobject context) {
    if (initialized_) {
        LOGI("Godot already initialized");
        return;
    }

    LOGI("Initializing Godot Engine...");
    jni_env_ = env;
    android_context_ = env->NewGlobalRef(context);

    // Initialize Godot engine here
    // This would call the actual Godot initialization

    initialized_ = true;
    LOGI("Godot Engine initialized successfully");
}

void GodotBridge::start_game(const std::string& craft_id,
                             const std::string& difficulty,
                             const std::string& graphics_quality) {
    if (!initialized_) {
        LOGE("Godot not initialized");
        return;
    }

    LOGI("Starting game: craft=%s, difficulty=%s, quality=%s",
         craft_id.c_str(), difficulty.c_str(), graphics_quality.c_str());

    // Call Godot to start game
    // This would invoke GDScript methods in Godot
}

void GodotBridge::pause_game() {
    LOGI("Pausing game");
    // Pause Godot simulation
}

void GodotBridge::resume_game() {
    LOGI("Resuming game");
    // Resume Godot simulation
}

void GodotBridge::toggle_camera() {
    LOGI("Toggling camera");
    // Call Godot camera toggle
}

std::string GodotBridge::get_game_state() {
    // Return JSON telemetry data
    return R"({
        "altitude": 250.0,
        "speed": 35.5,
        "health": 100.0,
        "heading": 45.0,
        "throttle": 75.0,
        "camera_mode": "3rd_person"
    })";
}

void GodotBridge::on_surface_created() {
    LOGI("Surface created");
}

void GodotBridge::on_surface_changed(int width, int height) {
    LOGI("Surface changed: %dx%d", width, height);
}

void GodotBridge::on_draw_frame() {
    // This is called each frame to render
    // Godot would handle rendering here
}

void GodotBridge::on_pause() {
    LOGI("Android app paused");
    pause_game();
}

void GodotBridge::on_resume() {
    LOGI("Android app resumed");
    resume_game();
}

void GodotBridge::on_destroy() {
    LOGI("Android app destroying");
    if (android_context_) {
        jni_env_->DeleteGlobalRef(android_context_);
        android_context_ = nullptr;
    }
    initialized_ = false;
}

void GodotBridge::on_touch_event(int action, float x, float y) {
    LOGI("Touch event: action=%d, x=%.2f, y=%.2f", action, x, y);
    // Route to Godot input system
}

void GodotBridge::on_sensor_event(float accel_x, float accel_y, float accel_z) {
    // Route accelerometer data to Godot
}

// JNI entry points

extern "C" {

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeInit(JNIEnv* env, jclass clazz, jobject context) {
    GodotBridge::init(env, context);
}

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeStartGame(JNIEnv* env, jclass clazz,
                                                          jstring craft_id,
                                                          jstring difficulty,
                                                          jstring quality) {
    const char* craft = env->GetStringUTFChars(craft_id, nullptr);
    const char* diff = env->GetStringUTFChars(difficulty, nullptr);
    const char* qual = env->GetStringUTFChars(quality, nullptr);

    GodotBridge::start_game(std::string(craft), std::string(diff), std::string(qual));

    env->ReleaseStringUTFChars(craft_id, craft);
    env->ReleaseStringUTFChars(difficulty, diff);
    env->ReleaseStringUTFChars(quality, qual);
}

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativePauseGame(JNIEnv* env, jclass clazz) {
    GodotBridge::pause_game();
}

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeResumeGame(JNIEnv* env, jclass clazz) {
    GodotBridge::resume_game();
}

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeToggleCamera(JNIEnv* env, jclass clazz) {
    GodotBridge::toggle_camera();
}

JNIEXPORT jstring JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeGetGameState(JNIEnv* env, jclass clazz) {
    std::string state = GodotBridge::get_game_state();
    return env->NewStringUTF(state.c_str());
}

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeOnTouchEvent(JNIEnv* env, jclass clazz,
                                                             jint action, jfloat x, jfloat y) {
    GodotBridge::on_touch_event(action, x, y);
}

JNIEXPORT void JNICALL
Java_com_oblivionedge_flight_GodotBridge_nativeOnSensorEvent(JNIEnv* env, jclass clazz,
                                                              jfloat ax, jfloat ay, jfloat az) {
    GodotBridge::on_sensor_event(ax, ay, az);
}

} // extern "C"

} // namespace godot_flutter
