import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriModel {
  final String? id;
  final String namaKategori;
  final String? deskripsi;
  final DateTime? createdAt;

  KategoriModel({
    this.id,
    required this.namaKategori,
    this.deskripsi,
    this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'nama_kategori': namaKategori,
      'deskripsi': deskripsi ?? '',
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory KategoriModel.fromMap(Map<String, dynamic> map, String id) {
    return KategoriModel(
      id: id,
      namaKategori: map['nama_kategori'] ?? '',
      deskripsi: map['deskripsi'],
      createdAt: map['created_at'] != null 
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  // Create from Firestore DocumentSnapshot
  factory KategoriModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KategoriModel.fromMap(data, doc.id);
  }

  // CopyWith method for updates
  KategoriModel copyWith({
    String? id,
    String? namaKategori,
    String? deskripsi,
    DateTime? createdAt,
  }) {
    return KategoriModel(
      id: id ?? this.id,
      namaKategori: namaKategori ?? this.namaKategori,
      deskripsi: deskripsi ?? this.deskripsi,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
