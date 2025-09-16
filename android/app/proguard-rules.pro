# Flutter ProGuard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# GetX
-keep class com.example.true_leaf_inventory_app.** { *; }
-keepclassmembers class * {
    @com.fasterxml.jackson.annotation.* *;
}

# PDF generation
-keep class com.pdf.** { *; }
-keep class org.apache.pdfbox.** { *; }

# Network and JSON
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }

# Dio HTTP client
-keep class dio.** { *; }