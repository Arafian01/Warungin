import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/barang_model.dart';

class BarangService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get collection reference - flat structure
  CollectionReference get _barangCollection => 
      _firestore.collection('barang');

  // Create barang
  Future<String> createBarang(BarangModel barang) async {
    try {
      DocumentReference docRef = await _barangCollection.add(barang.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Gagal menambah barang: ${e.toString()}');
    }
  }

  // Get all barang
  Stream<List<BarangModel>> getBarangStream() {
    return _barangCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BarangModel.fromSnapshot(doc))
            .toList());
  }

  // Get barang by kategori
  Stream<List<BarangModel>> getBarangByKategoriStream(String idKategori) {
    return _barangCollection
        .where('id_kategori', isEqualTo: idKategori)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BarangModel.fromSnapshot(doc))
            .toList());
  }

  // Get barang by ID
  Future<BarangModel?> getBarangById(String id) async {
    try {
      DocumentSnapshot doc = await _barangCollection.doc(id).get();
      if (doc.exists) {
        return BarangModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil barang: ${e.toString()}');
    }
  }

  // Update barang
  Future<void> updateBarang(String id, BarangModel barang) async {
    try {
      await _barangCollection.doc(id).update(barang.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate barang: ${e.toString()}');
    }
  }

  // Delete barang
  Future<void> deleteBarang(String id) async {
    try {
      await _barangCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus barang: ${e.toString()}');
    }
  }

  // Search barang
  Future<List<BarangModel>> searchBarang(String query) async {
    try {
      QuerySnapshot snapshot = await _barangCollection.get();
      
      List<BarangModel> allBarang = snapshot.docs
          .map((doc) => BarangModel.fromSnapshot(doc))
          .toList();
      
      // Filter by name
      return allBarang.where((barang) => 
          barang.namaBarang.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Gagal mencari barang: ${e.toString()}');
    }
  }
}
