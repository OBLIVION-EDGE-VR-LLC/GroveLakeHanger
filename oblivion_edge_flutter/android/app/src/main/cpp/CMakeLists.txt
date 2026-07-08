# CMakeLists.txt for Godot-Flutter JNI Bridge

cmake_minimum_required(VERSION 3.22)
project(godot_flutter_bridge)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add our JNI wrapper library
add_library(godot_flutter_bridge SHARED
    godot_wrapper.cpp
)

# Include directories
target_include_directories(godot_flutter_bridge PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${ANDROID_NDK}/sources/android/native_app_glue
)

# Link against Android libraries
target_link_libraries(godot_flutter_bridge PUBLIC
    android
    log
)

# Compiler flags
if(MSVC)
    target_compile_options(godot_flutter_bridge PRIVATE /W4)
else()
    target_compile_options(godot_flutter_bridge PRIVATE -Wall -Wextra -Wpedantic)
endif()
