# Panduan Setup Warungin

## Langkah-langkah Setup Firebase

### 1. Buat Firebase Project

1. Kunjungi [Firebase Console](https://console.firebase.google.com/)
2. Klik "Add project" atau "Tambah project"
3. Beri nama project: **Warungin**
4. Ikuti wizard setup hingga selesai

### 2. Aktifkan Firebase Authentication

1. Di Firebase Console, pilih project Warungin
2. Klik **Authentication** di menu sebelah kiri
3. Klik tab **Sign-in method**
4. Aktifkan **Email/Password**
5. Klik **Save**

### 3. Aktifkan Cloud Firestore

1. Klik **Firestore Database** di menu sebelah kiri
2. Klik **Create database**
3. Pilih **Start in test mode** (untuk development)
4. Pilih lokasi server (pilih yang terdekat, misalnya asia-southeast1)
5. Klik **Enable**

### 4. Setup Firestore Rules

Setelah Firestore aktif, update rules:

1. Klik tab **Rules**
2. Copy-paste rules berikut:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /kategori/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /barang/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /transaksi/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      match /detail_transaksi/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

3. Klik **Publish**

### 5. Setup Flutter App dengan Firebase

#### Install Firebase CLI

```bash
npm install -g firebase-tools
```

#### Login ke Firebase

```bash
firebase login
```

#### Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

#### Configure Firebase untuk Flutter

Di root folder project Warungin, jalankan:

```bash
flutterfire configure
```

Pilih:
- Project: **Warungin**
- Platforms: **Android** dan **iOS** (pilih sesuai kebutuhan)

Command ini akan membuat file `firebase_options.dart` secara otomatis.

### 6. Install Dependencies

```bash
flutter pub get
```

### 7. Run Aplikasi

```bash
flutter run
```

## Troubleshooting

### Error: "No Firebase App '[DEFAULT]' has been created"

**Solusi**: Pastikan `Firebase.initializeApp()` sudah dipanggil di `main.dart` sebelum `runApp()`.

### Error: "MissingPluginException"

**Solusi**: 
1. Stop aplikasi
2. Jalankan `flutter clean`
3. Jalankan `flutter pub get`
4. Rebuild aplikasi

### Error: "FirebaseException: PERMISSION_DENIED"

**Solusi**: Periksa Firestore Rules sudah benar dan user sudah login.

### Error saat build Android

**Solusi**: Pastikan `minSdkVersion` di `android/app/build.gradle` minimal 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21
        // ...
    }
}
```

## Testing Aplikasi

### 1. Register User Baru

1. Buka aplikasi
2. Klik "Daftar"
3. Isi form registrasi
4. Klik "Daftar"

### 2. Tambah Kategori

1. Login ke aplikasi
2. Klik tab "Kategori"
3. Klik tombol "+" (FAB)
4. Isi nama kategori (contoh: "Makanan")
5. Klik "Simpan"

### 3. Tambah Barang

1. Klik tab "Barang"
2. Klik tombol "+" (FAB)
3. Pilih kategori
4. Isi nama barang (contoh: "Indomie Goreng")
5. Isi harga (contoh: 3000)
6. Pilih satuan (contoh: "pcs")
7. Klik "Simpan"

### 4. Buat Transaksi

1. Klik tab "Transaksi"
2. Klik tombol "+" (FAB) atau "Pilih Barang"
3. Pilih barang yang ingin dijual
4. Isi jumlah
5. Klik "Tambah"
6. Ulangi untuk barang lain jika perlu
7. Pilih metode pembayaran
8. Tambah catatan (opsional)
9. Klik "Proses Transaksi"

### 5. Lihat Riwayat

1. Klik tab "Riwayat"
2. Lihat daftar transaksi
3. Klik transaksi untuk melihat detail

## Tips Development

1. **Hot Reload**: Tekan `r` di terminal saat aplikasi running untuk reload perubahan
2. **Hot Restart**: Tekan `R` untuk restart aplikasi
3. **Debug Mode**: Gunakan `flutter run --debug` untuk mode debug
4. **Release Mode**: Gunakan `flutter run --release` untuk testing performa

## Next Steps

Setelah setup selesai, Anda bisa:

1. Customize tema warna di `lib/utils/constants.dart`
2. Tambah fitur baru sesuai kebutuhan
3. Deploy ke Play Store / App Store
4. Tambah analytics dan crash reporting

## Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini.
