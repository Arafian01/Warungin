import 'package:intl/intl.dart';

class Formatters {
  // Format currency (Indonesian Rupiah)
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format date (dd MMM yyyy)
  static String date(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  // Format date with time (dd MMM yyyy HH:mm)
  static String dateTime(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy HH:mm', 'id_ID');
    return formatter.format(date);
  }

  // Format time only (HH:mm)
  static String time(DateTime date) {
    final formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }

  // Format number with thousand separator
  static String number(int number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number);
  }

  // Format decimal number
  static String decimal(double number, {int decimalDigits = 2}) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(number);
  }

  // Parse currency string to double
  static double parseCurrency(String value) {
    // Remove Rp, spaces, and dots
    String cleaned = value.replaceAll(RegExp(r'[Rp\s.]'), '');
    // Replace comma with dot
    cleaned = cleaned.replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }

  // Format phone number
  static String phoneNumber(String phone) {
    // Remove non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    if (cleaned.length >= 10) {
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4, 8)}-${cleaned.substring(8)}';
    }
    return phone;
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Format relative time (e.g., "2 jam yang lalu")
  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
