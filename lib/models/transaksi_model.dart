import 'package:cloud_firestore/cloud_firestore.dart';

class TransaksiModel {
  final String? id;
  final double totalHarga;
  final DateTime tanggal;
  final String? catatan;
  final DateTime? createdAt;

  TransaksiModel({
    this.id,
    required this.totalHarga,
    required this.tanggal,
    this.catatan,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'total_harga': totalHarga,
      'tanggal': Timestamp.fromDate(tanggal),
      'catatan': catatan,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory TransaksiModel.fromMap(Map<String, dynamic> map, String id) {
    return TransaksiModel(
      id: id,
      totalHarga: (map['total_harga'] ?? 0).toDouble(),
      tanggal: map['tanggal'] != null 
          ? (map['tanggal'] as Timestamp).toDate()
          : DateTime.now(),
      catatan: map['catatan'],
      createdAt: map['created_at'] != null 
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  factory TransaksiModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransaksiModel.fromMap(data, doc.id);
  }

  TransaksiModel copyWith({
    String? id,
    double? totalHarga,
    DateTime? tanggal,
    String? catatan,
    DateTime? createdAt,
  }) {
    return TransaksiModel(
      id: id ?? this.id,
      totalHarga: totalHarga ?? this.totalHarga,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
