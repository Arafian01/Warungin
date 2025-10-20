# 🚀 Quick Fix - MainActivity Error

## Error yang Terjadi
```
ClassNotFoundException: Didn't find class "com.warungin.app.MainActivity"
```

## ✅ Solusi Sudah Diterapkan

File `MainActivity.kt` baru sudah dibuat di lokasi yang benar:
```
android/app/src/main/kotlin/com/warungin/app/MainActivity.kt
```

## 🔧 Langkah-langkah Perbaikan

### Opsi 1: Menggunakan Script (Recommended)

Jalankan script helper yang sudah disediakan:

```bash
clean_build.bat
```

Script ini akan otomatis:
1. ✅ Flutter clean
2. ✅ Flutter pub get
3. ✅ Gradle clean
4. ✅ Siap untuk flutter run

### Opsi 2: Manual

Jalankan perintah berikut satu per satu:

```bash
# 1. Clean Flutter build
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Clean Android build
cd android
gradlew clean
cd ..

# 4. Run aplikasi
flutter run
```

## 📱 Setelah Clean Build

Setelah menjalankan clean build, jalankan aplikasi:

```bash
flutter run
```

Atau untuk device spesifik:

```bash
# Android
flutter run -d <device-id>

# List devices
flutter devices
```

## ⚠️ Catatan Penting

1. **Uninstall aplikasi lama** dari device/emulator jika masih ada error:
   ```bash
   adb uninstall com.warungin.app
   ```

2. **Restart Android Studio** jika menggunakan emulator dari AS

3. **Restart ADB** jika device tidak terdeteksi:
   ```bash
   adb kill-server
   adb start-server
   ```

## 🎯 Struktur Package Baru

```
android/app/src/main/
├── kotlin/
│   └── com/
│       └── warungin/
│           └── app/
│               └── MainActivity.kt  ← File baru (Kotlin)
└── java/
    └── com/
        └── rfcom/
            └── warungin/
                └── MainActivity.java  ← File lama (bisa dihapus)
```

## ✅ Checklist

Sebelum run, pastikan:

- [x] MainActivity.kt sudah dibuat di package `com.warungin.app`
- [x] build.gradle: `applicationId = "com.warungin.app"`
- [x] build.gradle: `namespace = "com.warungin.app"`
- [x] AndroidManifest.xml: label = "Warungin"
- [ ] Flutter clean sudah dijalankan
- [ ] Gradle clean sudah dijalankan
- [ ] Dependencies sudah di-get

## 🔍 Verifikasi

Setelah build berhasil, Anda akan melihat:

```
✓ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...
Debug service listening on ws://127.0.0.1:xxxxx/...
```

Aplikasi akan terbuka di device/emulator dengan splash screen Warungin.

## 🆘 Jika Masih Error

1. **Cek file MainActivity.kt ada dan benar:**
   ```
   android/app/src/main/kotlin/com/warungin/app/MainActivity.kt
   ```

2. **Uninstall aplikasi dari device:**
   ```bash
   adb uninstall com.warungin.app
   ```

3. **Clean build ulang:**
   ```bash
   flutter clean
   flutter pub get
   cd android
   gradlew clean
   cd ..
   ```

4. **Run dengan verbose:**
   ```bash
   flutter run -v
   ```

5. **Cek Android logs:**
   ```bash
   adb logcat | findstr "warungin"
   ```

## 📞 Support

Jika masih ada masalah, cek file:
- `TROUBLESHOOTING.md` - Panduan lengkap troubleshooting
- `FIREBASE_SETUP_COMPLETE.md` - Panduan setup Firebase

---

**Status:** ✅ Ready to build and run!

Jalankan: `clean_build.bat` kemudian `flutter run`
