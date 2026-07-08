package com.oblivionedge.flight;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize Godot bridge
        try {
            GodotBridge.INSTANCE.init(this);
        } catch (Exception e) {
            android.util.Log.e("MainActivity", "Failed to initialize Godot: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        GodotBridge.INSTANCE.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        GodotBridge.INSTANCE.onResume();
    }

    @Override
    protected void onDestroy() {
        GodotBridge.INSTANCE.onDestroy();
        super.onDestroy();
    }
}
