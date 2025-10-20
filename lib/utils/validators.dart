class Validators {
  // Email validator
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    
    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  // Confirm password validator
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak sama';
    }
    
    return null;
  }

  // Required field validator
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    return null;
  }

  // Number validator
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    
    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Field'} harus berupa angka';
    }
    
    return null;
  }

  // Positive number validator
  static String? positiveNumber(String? value, {String? fieldName}) {
    final numberError = number(value, fieldName: fieldName);
    if (numberError != null) return numberError;
    
    final numValue = double.parse(value!);
    if (numValue <= 0) {
      return '${fieldName ?? 'Field'} harus lebih dari 0';
    }
    
    return null;
  }

  // Integer validator
  static String? integer(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    
    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'Field'} harus berupa bilangan bulat';
    }
    
    return null;
  }

  // Positive integer validator
  static String? positiveInteger(String? value, {String? fieldName}) {
    final intError = integer(value, fieldName: fieldName);
    if (intError != null) return intError;
    
    final intValue = int.parse(value!);
    if (intValue <= 0) {
      return '${fieldName ?? 'Field'} harus lebih dari 0';
    }
    
    return null;
  }

  // Min length validator
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    
    if (value.length < minLength) {
      return '${fieldName ?? 'Field'} minimal $minLength karakter';
    }
    
    return null;
  }

  // Max length validator
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty for max length
    }
    
    if (value.length > maxLength) {
      return '${fieldName ?? 'Field'} maksimal $maxLength karakter';
    }
    
    return null;
  }

  // Phone number validator (Indonesian format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Remove non-digit characters
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    
    if (cleaned.length < 10 || cleaned.length > 13) {
      return 'Nomor telepon tidak valid';
    }
    
    if (!cleaned.startsWith('0') && !cleaned.startsWith('62')) {
      return 'Nomor telepon harus diawali 0 atau 62';
    }
    
    return null;
  }

  // Price validator
  static String? price(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga tidak boleh kosong';
    }
    
    final numValue = double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), ''));
    if (numValue == null) {
      return 'Harga tidak valid';
    }
    
    if (numValue < 0) {
      return 'Harga tidak boleh negatif';
    }
    
    return null;
  }
}
