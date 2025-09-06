
# InmoGestión

## 1) Requisitos

- **Flutter** 3.x o superior
   - Verifica con: `flutter --version 3.35.3`
- **Android Studio** (SDK + Platform Tools + Build-Tools)
   - Recomendado: Android SDK **35** (o 34) + Build-Tools **35.x**
- **Java JDK 17** (el que instala Android Studio está bien)
- **Git** (opcional, para clonar)
- (Opcional) **VS Code** con extensiones Flutter/Dart

> iOS requiere macOS con Xcode. Más abajo hay una nota rápida.

---

## 2) Instalación rápida

1. **Instala Flutter**
   - Windows (ejemplo):
     ```bat
     git clone https://github.com/flutter/flutter.git -b stable C:\dev\flutter
     setx PATH "%PATH%;C:\dev\flutter\bin"
     ```
   - Verifica:
     ```bat
     flutter doctor
     ```

2. **Android SDK + Herramientas** (Android Studio → *Settings*):
   - **SDK Platforms**: instala al menos **Android 14/15 (API 34/35)**.
   - **SDK Tools**: marca **Android SDK Build-Tools**, **Android SDK Command-line Tools**, **NDK (Side by side)** y **CMake**.
   - Acepta licencias:
     ```bat
     flutter doctor --android-licenses
     ```

3. **Configura la ruta del SDK Android en Flutter** (si es necesario):
   ```bat
   flutter config --android-sdk "D:\Android\Sdk"
   flutter doctor
   ```

---

## 3) Obtener el proyecto

- Si recibiste un ZIP: descomprímelo en una carpeta, p. ej. `C:\Users\TuUsuario\flutterProjects\inmogestion`.
- Si clonas:
  ```bash
  git clone <tu-repo> inmogestion
  cd inmogestion
  ```

> **Nota:** Si el ZIP trae solo `lib/` y `pubspec.yaml`, primero crea un proyecto base:
> ```bash
> flutter create inmogestion
> ```
> y luego **reemplaza** `lib/` y `pubspec.yaml` con los del ZIP.

---

## 4) Dependencias y assets

1. Instala dependencias:
   ```bash
   flutter pub get
   ```

2. Asegúrate de tener la imagen del login (opcional, pero recomendado):

   - Estructura:
     ```
     inmogestion/
     ├─ lib/
     ├─ assets/
     │  └─ images/
     │     └─ login_bg.png
     └─ pubspec.yaml
     ```
   - En `pubspec.yaml`:
     ```yaml
     flutter:
       uses-material-design: true
       assets:
         - assets/images/login_bg.png
     ```
   - Luego:
     ```bash
     flutter pub get
     ```

---

## 5) Ejecutar en Android

1. Conecta un dispositivo **con Depuración USB** o inicia un emulador desde Android Studio (AVD Manager).
2. Compila y ejecuta:
   ```bash
   flutter run
   ```
   - Para desactivar el banner de debug ya está configurado en `MaterialApp(debugShowCheckedModeBanner: false)`.
3. (Opcional) Modo **release**:
   ```bash
   flutter run --release
   ```

---

## 6) Errores comunes y soluciones

### ■ NDK (Side by side) / `ndk-bundle` corrupto
- Error típico:
  ```
  [CXX1101] NDK at ...\ndk-bundle did not have a source.properties file
  ```
- Solución:
   1. En Android Studio → SDK Tools: instala **NDK (Side by side)**.
   2. Borra `...\Android\Sdk\ndk-bundle`.
   3. (Opcional) Fija la versión en `android/app/build.gradle.kts`:
      ```kotlin
      android {
        ndkVersion = "26.1.10909125" // usa la que instalaste
      }
      ```
   4. Limpia y recompila:
      ```bash
      flutter clean
      flutter pub get
      flutter run
      ```

### ■ Gradle/AGP no compatibles
- Error tipo: “Minimum supported Gradle version is 8.9…”
- Abre `android/gradle/wrapper/gradle-wrapper.properties` y usa:
  ```
  distributionUrl=https\://services.gradle.org/distributions/gradle-8.9-all.zip
  ```
- Sincroniza desde Android Studio o vuelve a correr `flutter run`.

### ■ Licencias Android no aceptadas
```bash
flutter doctor --android-licenses
```
Acepta todas.

### ■ Assets no se ven
- Verifica ruta e indentación en `pubspec.yaml`.
- Ejecuta `flutter pub get`.
- Realiza **Hot Restart** o reinicia la app.

---

## 7) Estructura del proyecto

```
lib/
├─ main.dart
├─ router.dart
├─ core/
│  └─ db/
│     └─ app_database.dart            # SQLite (sqflite)
├─ features/
│  ├─ auth/
│  │  ├─ data/
│  │  │  └─ session_prefs.dart       # SharedPreferences (sesión)
│  │  └─ presentation/
│  │     └─ login_page.dart          # Login con fondo y frosted glass
│  └─ properties/
│     ├─ data/
│     │  ├─ models/
│     │  │  └─ property.dart         # Modelo
│     │  ├─ datasources/
│     │  │  └─ property_dao.dart     # DAO (CRUD SQLite)
│     │  └─ repositories/
│     │     └─ property_repository.dart
│     └─ presentation/
│        ├─ providers/
│        │  └─ property_provider.dart # Provider (estado)
│        ├─ pages/
│        │  ├─ property_list_page.dart
│        │  ├─ property_form_page.dart
│        │  └─ property_detail_page.dart
│        └─ widgets/
│           └─ property_card.dart
assets/
└─ images/
   └─ login_bg.jpg
```

---

## 8) Compilar APK de release (Android)

1. Compila:
   ```bash
   flutter build apk --release
   ```
   El APK quedará en `build/app/outputs/flutter-apk/app-release.apk`.

---

## 9) Nota rápida para iOS (opcional)

- Requiere **macOS + Xcode**.
- Instala CocoaPods:
  ```bash
  sudo gem install cocoapods
  ```
- En carpeta `ios/`:
  ```bash
  pod install
  ```
- Corre en simulador o dispositivo real:
  ```bash
  flutter run
  ```

---

