import 'package:cloud_firestore/cloud_firestore.dart';

class BarangSatuanModel {
  final String? id;
  final String idBarang;
  final String namaSatuan;
  final double hargaJual;
  final DateTime? createdAt;

  BarangSatuanModel({
    this.id,
    required this.idBarang,
    required this.namaSatuan,
    required this.hargaJual,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_barang': idBarang,
      'nama_satuan': namaSatuan,
      'harga_jual': hargaJual,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory BarangSatuanModel.fromMap(Map<String, dynamic> map, String id) {
    return BarangSatuanModel(
      id: id,
      idBarang: map['id_barang'] ?? '',
      namaSatuan: map['nama_satuan'] ?? '',
      hargaJual: (map['harga_jual'] ?? 0).toDouble(),
      createdAt: map['created_at'] != null
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  factory BarangSatuanModel.fromSnapshot(DocumentSnapshot doc) {
    return BarangSatuanModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  BarangSatuanModel copyWith({
    String? id,
    String? idBarang,
    String? namaSatuan,
    double? hargaJual,
    DateTime? createdAt,
  }) {
    return BarangSatuanModel(
      id: id ?? this.id,
      idBarang: idBarang ?? this.idBarang,
      namaSatuan: namaSatuan ?? this.namaSatuan,
      hargaJual: hargaJual ?? this.hargaJual,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
