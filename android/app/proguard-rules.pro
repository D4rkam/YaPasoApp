# 1. No tocar las clases de Flutter ni de la App
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 2. CRÍTICO: No tocar tus modelos. 
# Si ProGuard renombra "name" a "a", tu JSON del backend no va a encontrar dónde guardarse.
-keep class prueba_buffet.app.data.models.** { *; }

# 3. No tocar GetX (maneja mucha lógica interna que la ofuscación rompe)
-keep class com.getx.** { *; }

# 4. Mantener anotaciones (necesario para Pydantic-like en Dart)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

# Resolver errores de Missing Classes de Google Play Core
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**