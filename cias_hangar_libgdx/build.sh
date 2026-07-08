#!/bin/bash

# CIA's Aircraft Hangar - LibGDX Build Script
# Builds the Android APK for deployment

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "🔨 CIA's Aircraft Hangar - LibGDX Build"
echo "========================================"
echo ""

# Check for Android SDK
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  ANDROID_HOME not set"
    echo "Setting default: $HOME/Android/Sdk"
    export ANDROID_HOME="$HOME/Android/Sdk"
fi

# Verify Android SDK exists
if [ ! -d "$ANDROID_HOME" ]; then
    echo "❌ ERROR: Android SDK not found at $ANDROID_HOME"
    echo "Please set ANDROID_HOME to your Android SDK installation path"
    exit 1
fi

echo "✅ Android SDK: $ANDROID_HOME"
echo "✅ Java Version: $(java -version 2>&1 | head -1)"
echo ""

# Clean previous build
echo "🧹 Cleaning previous build..."
gradle clean --warning-mode=none 2>&1 | grep -E "(BUILD|FAILURE|error)" || true

echo ""
echo "🔨 Building APK..."
gradle assembleDebug --warning-mode=none

APK_PATH="android/build/outputs/apk/debug/android-debug.apk"

if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo ""
    echo "✅ BUILD SUCCESSFUL!"
    echo ""
    echo "📦 APK Details:"
    echo "   Path: $APK_PATH"
    echo "   Size: $APK_SIZE"
    echo ""
    echo "🚀 To install on Pixel phone:"
    echo "   adb install -r $APK_PATH"
    echo ""
    echo "🎮 To launch the game:"
    echo "   adb shell am start -n com.cias.aircrafthangar/.AndroidLauncher"
else
    echo ""
    echo "❌ BUILD FAILED!"
    echo "APK not found at: $APK_PATH"
    exit 1
fi
