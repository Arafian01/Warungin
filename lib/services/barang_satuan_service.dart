import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/barang_satuan_model.dart';

class BarangSatuanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference - flat structure
  CollectionReference get _collection {
    return _firestore.collection('barang_satuan');
  }

  // Create barang satuan
  Future<String?> createBarangSatuan(BarangSatuanModel barangSatuan) async {
    try {
      final docRef = await _collection.add(barangSatuan.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating barang satuan: $e');
      return null;
    }
  }

  // Get all barang satuan
  Stream<List<BarangSatuanModel>> getAllBarangSatuan() {
    return _collection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BarangSatuanModel.fromSnapshot(doc))
          .toList();
    });
  }

  // Get barang satuan by barang ID
  Stream<List<BarangSatuanModel>> getBarangSatuanByBarangId(String idBarang) {
    return _collection
        .where('id_barang', isEqualTo: idBarang)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BarangSatuanModel.fromSnapshot(doc))
          .toList();
    });
  }

  // Get single barang satuan by ID
  Future<BarangSatuanModel?> getBarangSatuanById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (doc.exists) {
        return BarangSatuanModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      print('Error getting barang satuan: $e');
      return null;
    }
  }

  // Update barang satuan
  Future<bool> updateBarangSatuan(String id, BarangSatuanModel barangSatuan) async {
    try {
      await _collection.doc(id).update(barangSatuan.toMap());
      return true;
    } catch (e) {
      print('Error updating barang satuan: $e');
      return false;
    }
  }

  // Delete barang satuan
  Future<bool> deleteBarangSatuan(String id) async {
    try {
      await _collection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting barang satuan: $e');
      return false;
    }
  }

  // Delete all barang satuan for a specific barang
  Future<bool> deleteBarangSatuanByBarangId(String idBarang) async {
    try {
      final snapshot = await _collection
          .where('id_barang', isEqualTo: idBarang)
          .get();
      
      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      return true;
    } catch (e) {
      print('Error deleting barang satuan by barang id: $e');
      return false;
    }
  }

  // Check if barang has any satuan
  Future<bool> hasBarangSatuan(String idBarang) async {
    try {
      final snapshot = await _collection
          .where('id_barang', isEqualTo: idBarang)
          .limit(1)
          .get();
      
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking barang satuan: $e');
      return false;
    }
  }

  // Get barang satuan count for a barang
  Future<int> getBarangSatuanCount(String idBarang) async {
    try {
      final snapshot = await _collection
          .where('id_barang', isEqualTo: idBarang)
          .get();
      
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting barang satuan count: $e');
      return 0;
    }
  }

  // Search barang satuan by nama satuan
  Stream<List<BarangSatuanModel>> searchBarangSatuan(String query) {
    return _collection
        .orderBy('nama_satuan')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BarangSatuanModel.fromSnapshot(doc))
          .where((satuan) => satuan.namaSatuan.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
