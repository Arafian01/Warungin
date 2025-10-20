# Warungin 🏪

Aplikasi kasir sederhana untuk pemilik toko kelontong kecil. Dibuat dengan Flutter dan Firebase.

## 📱 Fitur Utama

- **Autentikasi** - Login & Register dengan Firebase Authentication
- **Kelola Kategori** - Tambah, edit, hapus kategori barang
- **Kelola Barang** - Manajemen data barang dengan kategori
- **Transaksi** - Buat transaksi penjualan dengan keranjang belanja
- **Riwayat** - Lihat dan kelola riwayat transaksi

## 🎨 Desain

- **Tema Warna**: Merah (#D32F2F)
- **Font**: Poppins (Google Fonts)
- **Gaya**: Minimalis dan modern
- **Navigasi**: Bottom Navigation Bar

## 🛠️ Teknologi

- **Framework**: Flutter
- **Backend**: Firebase Firestore
- **Authentication**: Firebase Auth
- **State Management**: Provider
- **Bahasa**: Dart

## 📁 Struktur Folder

```
lib/
├── main.dart
├── models/              # Data models
│   ├── kategori_model.dart
│   ├── barang_model.dart
│   ├── transaksi_model.dart
│   ├── detail_transaksi_model.dart
│   └── user_model.dart
├── providers/           # State management
│   ├── auth_provider.dart
│   ├── kategori_provider.dart
│   ├── barang_provider.dart
│   ├── transaksi_provider.dart
│   └── cart_provider.dart
├── services/            # Firebase services
│   ├── auth_service.dart
│   ├── kategori_service.dart
│   ├── barang_service.dart
│   └── transaksi_service.dart
├── pages/               # UI screens
│   ├── splash_page.dart
│   ├── auth/
│   ├── dashboard/
│   ├── kategori/
│   ├── barang/
│   ├── transaksi/
│   └── riwayat/
├── widgets/             # Reusable widgets
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── custom_card.dart
│   └── ...
└── utils/               # Utilities
    ├── constants.dart
    ├── formatters.dart
    ├── validators.dart
    └── helpers.dart
```

## 🔧 Setup & Instalasi

### Prerequisites

- Flutter SDK (3.6.2 atau lebih baru)
- Dart SDK
- Android Studio / VS Code
- Firebase Project

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd warungin
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Buat project baru di [Firebase Console](https://console.firebase.google.com/)
   - Aktifkan Firebase Authentication (Email/Password)
   - Aktifkan Cloud Firestore
   - Download `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS)
   - Letakkan file konfigurasi di folder yang sesuai

4. **Generate Firebase Options**
   ```bash
   flutterfire configure
   ```

5. **Run aplikasi**
   ```bash
   flutter run
   ```

## 🔥 Konfigurasi Firebase

### Firestore Rules (Development)

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

### Firestore Indexes

Buat indexes berikut di Firebase Console:

- Collection: `transaksi`
  - Fields: `tanggal` (Descending), `created_at` (Descending)

## 📊 Struktur Database

### Collection: users/{userId}/kategori
```json
{
  "nama_kategori": "Makanan",
  "deskripsi": "Kategori untuk makanan",
  "created_at": "timestamp"
}
```

### Collection: users/{userId}/barang
```json
{
  "id_kategori": "kategori_id",
  "nama_barang": "Indomie Goreng",
  "harga": 3000,
  "satuan": "pcs",
  "created_at": "timestamp"
}
```

### Collection: users/{userId}/transaksi
```json
{
  "tanggal": "timestamp",
  "total": 15000,
  "metode": "Tunai",
  "catatan": "Catatan transaksi",
  "created_at": "timestamp"
}
```

### Collection: users/{userId}/detail_transaksi
```json
{
  "id_transaksi": "transaksi_id",
  "id_barang": "barang_id",
  "nama_barang": "Indomie Goreng",
  "jumlah": 5,
  "harga_satuan": 3000,
  "subtotal": 15000,
  "created_at": "timestamp"
}
```

## 🚀 Cara Penggunaan

1. **Register/Login** - Buat akun atau masuk dengan akun yang sudah ada
2. **Tambah Kategori** - Buat kategori untuk mengelompokkan barang
3. **Tambah Barang** - Masukkan data barang dengan harga dan satuan
4. **Buat Transaksi** - Pilih barang, tentukan jumlah, dan proses pembayaran
5. **Lihat Riwayat** - Cek riwayat transaksi yang sudah dilakukan

## 📝 Catatan Pengembangan

- Aplikasi ini single-user (satu pemilik toko per perangkat)
- Tidak ada fitur stok barang otomatis
- Tidak ada laporan keuangan kompleks
- Fokus pada kemudahan dan kecepatan transaksi

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan buat pull request atau laporkan issue.

## 📄 License

MIT License

## 👨‍💻 Developer

Dibuat dengan ❤️ untuk membantu pemilik warung kelontong
