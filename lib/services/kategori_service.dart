import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kategori_model.dart';

class KategoriService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get collection reference - flat structure
  CollectionReference get _kategoriCollection => 
      _firestore.collection('kategori');

  // Create kategori
  Future<String> createKategori(KategoriModel kategori) async {
    try {
      DocumentReference docRef = await _kategoriCollection.add(kategori.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Gagal menambah kategori: ${e.toString()}');
    }
  }

  // Get all kategori
  Stream<List<KategoriModel>> getKategoriStream() {
    return _kategoriCollection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => KategoriModel.fromSnapshot(doc))
            .toList());
  }

  // Get kategori by ID
  Future<KategoriModel?> getKategoriById(String id) async {
    try {
      DocumentSnapshot doc = await _kategoriCollection.doc(id).get();
      if (doc.exists) {
        return KategoriModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil kategori: ${e.toString()}');
    }
  }

  // Update kategori
  Future<void> updateKategori(String id, KategoriModel kategori) async {
    try {
      await _kategoriCollection.doc(id).update(kategori.toMap());
    } catch (e) {
      throw Exception('Gagal mengupdate kategori: ${e.toString()}');
    }
  }

  // Delete kategori
  Future<void> deleteKategori(String id) async {
    try {
      await _kategoriCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Gagal menghapus kategori: ${e.toString()}');
    }
  }

  // Search kategori
  Future<List<KategoriModel>> searchKategori(String query) async {
    try {
      QuerySnapshot snapshot = await _kategoriCollection.get();
      
      List<KategoriModel> allKategori = snapshot.docs
          .map((doc) => KategoriModel.fromSnapshot(doc))
          .toList();
      
      // Filter by name
      return allKategori.where((kategori) => 
          kategori.namaKategori.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Gagal mencari kategori: ${e.toString()}');
    }
  }
}
