import 'package:flutter/material.dart';

// App Colors
class AppColors {
  static const Color primary = Color(0xFFD32F2F); // Merah
  static const Color secondary = Color(0xFFFFFFFF); // Putih
  static const Color background = Color(0xFFF5F5F5); // Abu-abu muda
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE0E0E0);
}

// App Text Styles
class AppTextStyles {
  static const String fontFamily = 'Poppins';
  
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

// App Dimensions
class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  
  static const double borderRadius = 12.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusLarge = 16.0;
  
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeLarge = 32.0;
  
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
}

// App Strings
class AppStrings {
  static const String appName = 'Warungin';
  static const String appTagline = 'Kasir Warung Praktis';
  
  // Auth
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String logout = 'Keluar';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Konfirmasi Password';
  static const String displayName = 'Nama Lengkap';
  static const String forgotPassword = 'Lupa Password?';
  
  // Navigation
  static const String dashboard = 'Dashboard';
  static const String kategori = 'Kategori';
  static const String barang = 'Barang';
  static const String transaksi = 'Transaksi';
  static const String riwayat = 'Riwayat';
  
  // Actions
  static const String add = 'Tambah';
  static const String edit = 'Edit';
  static const String delete = 'Hapus';
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String search = 'Cari';
  static const String confirm = 'Konfirmasi';
  
  // Messages
  static const String deleteConfirmation = 'Apakah Anda yakin ingin menghapus?';
  static const String successAdd = 'Berhasil ditambahkan';
  static const String successUpdate = 'Berhasil diupdate';
  static const String successDelete = 'Berhasil dihapus';
  static const String errorOccurred = 'Terjadi kesalahan';
  static const String noData = 'Tidak ada data';
  static const String loading = 'Memuat...';
}

// Metode Pembayaran
class PaymentMethods {
  static const String cash = 'Tunai';
  static const String transfer = 'Transfer';
  static const String qris = 'QRIS';
  static const String eWallet = 'E-Wallet';
  
  static List<String> getAll() {
    return [cash, transfer, qris, eWallet];
  }
}

// Satuan Barang
class ProductUnits {
  static const String pcs = 'pcs';
  static const String kg = 'kg';
  static const String gram = 'gram';
  static const String liter = 'liter';
  static const String ml = 'ml';
  static const String pack = 'pack';
  static const String box = 'box';
  
  static List<String> getAll() {
    return [pcs, kg, gram, liter, ml, pack, box];
  }
}
