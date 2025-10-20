import 'package:cloud_firestore/cloud_firestore.dart';

class DetailTransaksiModel {
  final String? id;
  final String idTransaksi;
  final String idBarangSatuan;
  final String idBarang;
  final String namaBarang;
  final int jumlah;
  final DateTime? createdAt;

  DetailTransaksiModel({
    this.id,
    required this.idTransaksi,
    required this.idBarangSatuan,
    required this.idBarang,
    required this.namaBarang,
    required this.jumlah,
    this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id_transaksi': idTransaksi,
      'id_barang_satuan': idBarangSatuan,
      'id_barang': idBarang,
      'nama_barang': namaBarang,
      'jumlah': jumlah,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory DetailTransaksiModel.fromMap(Map<String, dynamic> map, String id) {
    return DetailTransaksiModel(
      id: id,
      idTransaksi: map['id_transaksi'] ?? '',
      idBarangSatuan: map['id_barang_satuan'] ?? '',
      idBarang: map['id_barang'] ?? '',
      namaBarang: map['nama_barang'] ?? '',
      jumlah: map['jumlah'] ?? 0,
      createdAt: map['created_at'] != null 
          ? (map['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  // Create from Firestore DocumentSnapshot
  factory DetailTransaksiModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DetailTransaksiModel.fromMap(data, doc.id);
  }

  // CopyWith method for updates
  DetailTransaksiModel copyWith({
    String? id,
    String? idTransaksi,
    String? idBarangSatuan,
    String? idBarang,
    String? namaBarang,
    int? jumlah,
    DateTime? createdAt,
  }) {
    return DetailTransaksiModel(
      id: id ?? this.id,
      idTransaksi: idTransaksi ?? this.idTransaksi,
      idBarangSatuan: idBarangSatuan ?? this.idBarangSatuan,
      idBarang: idBarang ?? this.idBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      jumlah: jumlah ?? this.jumlah,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
