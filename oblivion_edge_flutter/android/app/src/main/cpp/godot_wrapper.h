#ifndef GODOT_FLUTTER_BRIDGE_H
#define GODOT_FLUTTER_BRIDGE_H

#include <jni.h>
#include <string>

namespace godot_flutter {

class GodotBridge {
public:
    /**
     * Initialize Godot engine with Android context
     */
    static void init(JNIEnv* env, jobject context);

    /**
     * Start game with craft parameters
     */
    static void start_game(const std::string& craft_id,
                           const std::string& difficulty,
                           const std::string& graphics_quality);

    /**
     * Pause the game
     */
    static void pause_game();

    /**
     * Resume the game
     */
    static void resume_game();

    /**
     * Toggle camera (1st/3rd person)
     */
    static void toggle_camera();

    /**
     * Get current game state (telemetry)
     */
    static std::string get_game_state();

    /**
     * Handle Android lifecycle
     */
    static void on_surface_created();
    static void on_surface_changed(int width, int height);
    static void on_draw_frame();
    static void on_pause();
    static void on_resume();
    static void on_destroy();

    /**
     * Handle input events
     */
    static void on_touch_event(int action, float x, float y);
    static void on_sensor_event(float accel_x, float accel_y, float accel_z);

private:
    static bool initialized_;
    static JNIEnv* jni_env_;
    static jobject android_context_;
};

} // namespace godot_flutter

#endif // GODOT_FLUTTER_BRIDGE_H
