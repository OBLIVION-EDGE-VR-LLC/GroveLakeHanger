#!/bin/bash

# Oblivion Edge - Build & Run on Android Device
# This script builds the APK and installs it on your connected Android device

set -e

PROJECT_DIR="/home/bdg/Documents/projects/OBLIVION_EDGE_LLC/ResearchAndDev/Android/oblivion_edge_flutter"

echo "═══════════════════════════════════════════════════════════════════════"
echo "Oblivion Edge: Build & Run on Device"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""

# Check if device is connected
echo "→ Checking for connected devices..."
DEVICE_COUNT=$(adb devices | grep -c "device$")
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "❌ No Android devices connected!"
    echo "Please connect an Android device via USB and enable USB debugging."
    exit 1
fi
echo "✓ Device connected"
echo ""

# Clean build
echo "→ Cleaning previous builds..."
cd "$PROJECT_DIR"
rm -rf build
flutter clean
echo "✓ Cleaned"
echo ""

# Get dependencies
echo "→ Getting dependencies..."
flutter pub get
echo "✓ Dependencies installed"
echo ""

# Build APK
echo "→ Building APK (this may take a minute)..."
flutter build apk --debug --no-shrink
echo "✓ APK built"
echo ""

# Install APK
echo "→ Installing APK on device..."
APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
if [ ! -f "$APK_PATH" ]; then
    echo "❌ APK not found at $APK_PATH"
    exit 1
fi

adb install -r "$APK_PATH"
echo "✓ APK installed"
echo ""

# Launch app
echo "→ Launching app..."
adb shell am start -n com.oblivionedge.flight/.MainActivity
echo "✓ App launched"
echo ""

# Show logs
echo "→ Streaming logs (Ctrl+C to stop)..."
echo ""
sleep 2
adb logcat -s flutter,oblivionedge,MainActivity | grep -E "(flutter|oblivionedge|MainActivity|I:|E:|D:)"

echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo "✅ Done!"
echo "═══════════════════════════════════════════════════════════════════════"
