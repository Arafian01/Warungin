import 'package:cloud_firestore/cloud_firestore.dart';

class BarangModel {
  final String? id;
  final String idKategori;
  final String namaBarang;
  final DateTime? createdAt;

  BarangModel({
    this.id,
    required this.idKategori,
    required this.namaBarang,
    this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id_kategori': idKategori,
      'nama_barang': namaBarang,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory BarangModel.fromMap(Map<String, dynamic> map, String id) {
    return BarangModel(
      id: id,
      idKategori: map['id_kategori'] ?? '',
      namaBarang: map['nama_barang'] ?? '',
      createdAt: map['created_at'] != null 
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  // Create from Firestore DocumentSnapshot
  factory BarangModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BarangModel.fromMap(data, doc.id);
  }

  // CopyWith method for updates
  BarangModel copyWith({
    String? id,
    String? idKategori,
    String? namaBarang,
    DateTime? createdAt,
  }) {
    return BarangModel(
      id: id ?? this.id,
      idKategori: idKategori ?? this.idKategori,
      namaBarang: namaBarang ?? this.namaBarang,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
