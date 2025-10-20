# Troubleshooting Guide - Warungin

## ✅ Solved Issues

### 1. MainActivity ClassNotFoundException

**Error:**
```
java.lang.ClassNotFoundException: Didn't find class "com.warungin.app.MainActivity"
```

**Cause:**
MainActivity masih ada di package lama setelah mengubah applicationId.

**Solution:**
1. MainActivity baru sudah dibuat di `android/app/src/main/kotlin/com/warungin/app/MainActivity.kt`
2. Clean dan rebuild:

```bash
flutter clean
flutter pub get
cd android
gradlew clean
cd ..
flutter run
```

Atau gunakan script helper:
```bash
clean_build.bat
```

**Status:** ✅ Fixed - MainActivity created in correct package

---

### 2. AuthProvider Import Conflict

**Error:**
```
'AuthProvider' is imported from both 'package:firebase_auth_platform_interface/src/auth_provider.dart' 
and 'package:warungin/providers/auth_provider.dart'.
```

**Cause:**
Konflik nama antara `AuthProvider` dari Firebase Auth dan custom `AuthProvider` kita.

**Solution:**
Gunakan alias import untuk custom AuthProvider:

```dart
// BEFORE (Error)
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart';

// AFTER (Fixed)
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/auth_provider.dart' as auth_provider;

// Usage
Provider.of<auth_provider.AuthProvider>(context, listen: false)
```

**Status:** ✅ Fixed in `lib/pages/dashboard/dashboard_page.dart`

---

## Common Issues & Solutions

### 2. No Firebase App '[DEFAULT]' has been created

**Error:**
```
[core/no-app] No Firebase App '[DEFAULT]' has been created
```

**Solution:**
Pastikan `Firebase.initializeApp()` dipanggil di `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

**Status:** ✅ Already configured

---

### 3. MissingPluginException

**Error:**
```
MissingPluginException(No implementation found for method...)
```

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

Atau untuk Android:
```bash
cd android
./gradlew clean
cd ..
flutter run
```

---

### 4. PERMISSION_DENIED di Firestore

**Error:**
```
[cloud_firestore/permission-denied] The caller does not have permission
```

**Solution:**
1. Pastikan user sudah login
2. Cek Firestore Rules di Firebase Console
3. Update rules sesuai dokumentasi:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

---

### 5. Build Failed - Gradle Error

**Error:**
```
Execution failed for task ':app:compileFlutterBuildDebug'
```

**Solution:**
1. Check `minSdk` version (harus minimal 21):
```gradle
// android/app/build.gradle
defaultConfig {
    minSdk = 21
}
```

2. Clean dan rebuild:
```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

**Status:** ✅ Already configured (minSdk = 21)

---

### 6. Google Services Plugin Error

**Error:**
```
Plugin with id 'com.google.gms.google-services' not found
```

**Solution:**
Pastikan plugin sudah ditambahkan di `android/settings.gradle`:

```gradle
plugins {
    id "com.google.gms.google-services" version "4.4.0" apply false
}
```

Dan di `android/app/build.gradle`:

```gradle
plugins {
    id "com.google.gms.google-services"
}
```

**Status:** ✅ Already configured

---

### 7. Package Name Mismatch

**Error:**
```
The package name does not match the applicationId
```

**Solution:**
Pastikan semua package name konsisten:

1. `android/app/build.gradle`:
```gradle
android {
    namespace = "com.warungin.app"
    defaultConfig {
        applicationId = "com.warungin.app"
    }
}
```

2. `android/app/google-services.json`:
```json
"package_name": "com.warungin.app"
```

**Status:** ✅ Already configured

---

### 8. Dependency Version Conflicts

**Error:**
```
Version conflict for dependency...
```

**Solution:**
Update dependencies di `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.2
  provider: ^6.1.2
  intl: ^0.19.0
```

Kemudian:
```bash
flutter pub upgrade
flutter pub get
```

---

### 9. Hot Reload Not Working

**Solution:**
1. Stop aplikasi
2. Run ulang dengan:
```bash
flutter run --no-sound-null-safety
```

Atau restart dengan `R` di terminal

---

### 10. Emulator/Device Not Detected

**Solution:**

**Android:**
```bash
flutter devices
adb devices
```

Jika tidak terdeteksi:
```bash
adb kill-server
adb start-server
```

**Chrome (Web):**
```bash
flutter run -d chrome
```

---

## Debug Commands

### Check Flutter Doctor
```bash
flutter doctor -v
```

### Check Dependencies
```bash
flutter pub deps
```

### Analyze Code
```bash
flutter analyze
```

### Run with Verbose
```bash
flutter run -v
```

### Clean Build
```bash
flutter clean
flutter pub get
flutter run
```

---

## Firebase Console Checklist

- [ ] Authentication → Email/Password enabled
- [ ] Firestore Database created
- [ ] Firestore Rules updated
- [ ] App registered (Android/iOS/Web)
- [ ] google-services.json downloaded (Android)
- [ ] GoogleService-Info.plist downloaded (iOS)

---

## Performance Tips

1. **Use Release Mode for Testing Performance:**
```bash
flutter run --release
```

2. **Profile Mode:**
```bash
flutter run --profile
```

3. **Build APK:**
```bash
flutter build apk --release
```

4. **Build App Bundle:**
```bash
flutter build appbundle --release
```

---

## Getting Help

1. Check Flutter logs:
```bash
flutter logs
```

2. Check Android logs:
```bash
adb logcat
```

3. Enable verbose logging in code:
```dart
// main.dart
void main() {
  debugPrint('App starting...');
  // ...
}
```

---

## Contact & Support

Jika masalah masih berlanjut:
1. Buat issue di repository
2. Sertakan error log lengkap
3. Sertakan versi Flutter (`flutter --version`)
4. Sertakan platform yang digunakan (Android/iOS/Web)
