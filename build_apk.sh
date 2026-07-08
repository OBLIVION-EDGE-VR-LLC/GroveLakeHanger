#!/bin/bash

# CIA's Aircraft Hangar - Docker APK Build Script
# Builds the Android APK using Godot Docker image

set -e

PROJECT_ROOT="/home/bdg/Documents/projects/OBLIVION_EDGE_LLC/ResearchAndDev/Android"
PROJECT_DIR="$PROJECT_ROOT/godot_game"
OUTPUT_APK="$PROJECT_ROOT/cias_aircraft_hangar_phase1.apk"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║   CIA's Aircraft Hangar - APK Build (Docker)                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ ERROR: Docker is not installed"
    echo ""
    echo "Install Docker:"
    echo "  Ubuntu/Debian: sudo apt-get install docker.io"
    echo "  Fedora: sudo dnf install docker"
    echo "  macOS: brew install docker"
    echo ""
    echo "Or visit: https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✓ Docker found: $(docker --version)"
echo ""

# Check if project directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ ERROR: Project directory not found: $PROJECT_DIR"
    exit 1
fi

echo "✓ Project directory: $PROJECT_DIR"
echo ""

# Check if project.godot exists
if [ ! -f "$PROJECT_DIR/project.godot" ]; then
    echo "❌ ERROR: project.godot not found in $PROJECT_DIR"
    exit 1
fi

echo "✓ Godot project file found"
echo ""

echo "════════════════════════════════════════════════════════════════"
echo "Building APK with Godot Docker image..."
echo "════════════════════════════════════════════════════════════════"
echo ""

# Pull the latest godot-ci image
echo "→ Pulling Godot CI image (barichello/godot-ci:4.7)..."
docker pull barichello/godot-ci:4.7 2>&1 | grep -E "(Pulling|Downloaded|Already|Digest)" || true

echo ""
echo "→ Building APK (this may take 2-5 minutes)..."
echo ""

# Run the Docker build (headless mode for export)
docker run \
  --rm \
  -v "$PROJECT_DIR:/root/project" \
  barichello/godot-ci:4.7 \
  godot --headless --path /root/project --export-release "cias_aircraft_hangar.apk" /root/project/cias_aircraft_hangar_phase1.apk

# Check if build succeeded
if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "✅ APK BUILD SUCCESSFUL!"
    echo "════════════════════════════════════════════════════════════════"
    echo ""

    if [ -f "$PROJECT_DIR/cias_aircraft_hangar_phase1.apk" ]; then
        APK_SIZE=$(du -h "$PROJECT_DIR/cias_aircraft_hangar_phase1.apk" | cut -f1)
        echo "📦 APK File: $PROJECT_DIR/cias_aircraft_hangar_phase1.apk"
        echo "📊 Size: $APK_SIZE"
        echo ""
        echo "════════════════════════════════════════════════════════════════"
        echo "Next steps:"
        echo "════════════════════════════════════════════════════════════════"
        echo ""
        echo "1. Install on connected Android device:"
        echo "   adb install -r \"$PROJECT_DIR/cias_aircraft_hangar_phase1.apk\""
        echo ""
        echo "2. Or transfer APK to your device manually:"
        echo "   Location: $PROJECT_DIR/cias_aircraft_hangar_phase1.apk"
        echo ""
        echo "3. Launch the game:"
        echo "   adb shell am start -n com.cias.aircrafthangar/.MainActivity"
        echo ""
    else
        echo "⚠️  APK file not found at expected location"
        echo "Checking $PROJECT_DIR..."
        ls -lah "$PROJECT_DIR"/*.apk 2>/dev/null || echo "No APK files found"
    fi
else
    echo ""
    echo "❌ BUILD FAILED"
    echo ""
    echo "Troubleshooting:"
    echo "1. Check Docker is running: docker ps"
    echo "2. Check disk space: df -h"
    echo "3. Check project files: ls -la $PROJECT_DIR/"
    echo ""
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    Build Complete! 🚀                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
