# LibGDX ProGuard rules
-keep class com.badlogic.** { *; }
-keepclassmembers enum com.badlogic.** { *; }

# Game classes
-keep class com.cias.aircrafthangar.** { *; }
-keepclassmembers class com.cias.aircrafthangar.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep view constructors for layout inflation
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

# Preserve source file and line numbers
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
