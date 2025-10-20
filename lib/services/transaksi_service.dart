import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';

class TransaksiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get collection reference - flat structure
  CollectionReference get _transaksiCollection => 
      _firestore.collection('transaksi');
  
  CollectionReference get _detailTransaksiCollection => 
      _firestore.collection('detail_transaksi');

  // Create transaksi with details
  Future<String> createTransaksi(
    TransaksiModel transaksi,
    List<DetailTransaksiModel> details,
  ) async {
    try {
      // Create transaksi
      DocumentReference transaksiRef = await _transaksiCollection.add(transaksi.toMap());
      String transaksiId = transaksiRef.id;
      
      // Create detail transaksi
      WriteBatch batch = _firestore.batch();
      for (var detail in details) {
        var detailWithId = detail.copyWith(idTransaksi: transaksiId);
        DocumentReference detailRef = _detailTransaksiCollection.doc();
        batch.set(detailRef, detailWithId.toMap());
      }
      await batch.commit();
      
      return transaksiId;
    } catch (e) {
      throw Exception('Gagal membuat transaksi: ${e.toString()}');
    }
  }

  // Get all transaksi
  Stream<List<TransaksiModel>> getTransaksiStream() {
    return _transaksiCollection
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransaksiModel.fromSnapshot(doc))
            .toList());
  }

  // Get transaksi by date range
  Stream<List<TransaksiModel>> getTransaksiByDateRangeStream(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transaksiCollection
        .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransaksiModel.fromSnapshot(doc))
            .toList());
  }

  // Get transaksi by ID
  Future<TransaksiModel?> getTransaksiById(String id) async {
    try {
      DocumentSnapshot doc = await _transaksiCollection.doc(id).get();
      if (doc.exists) {
        return TransaksiModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil transaksi: ${e.toString()}');
    }
  }

  // Get detail transaksi by transaksi ID
  Future<List<DetailTransaksiModel>> getDetailTransaksi(String idTransaksi) async {
    try {
      QuerySnapshot snapshot = await _detailTransaksiCollection
          .where('id_transaksi', isEqualTo: idTransaksi)
          .get();
      
      return snapshot.docs
          .map((doc) => DetailTransaksiModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil detail transaksi: ${e.toString()}');
    }
  }

  // Delete transaksi and its details
  Future<void> deleteTransaksi(String id) async {
    try {
      // Delete detail transaksi first
      QuerySnapshot detailSnapshot = await _detailTransaksiCollection
          .where('id_transaksi', isEqualTo: id)
          .get();
      
      WriteBatch batch = _firestore.batch();
      for (var doc in detailSnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      // Delete transaksi
      batch.delete(_transaksiCollection.doc(id));
      
      await batch.commit();
    } catch (e) {
      throw Exception('Gagal menghapus transaksi: ${e.toString()}');
    }
  }

  // Search transaksi by item name
  Future<List<TransaksiModel>> searchTransaksiByItem(String query) async {
    try {
      // Get all detail transaksi that match the query
      QuerySnapshot detailSnapshot = await _detailTransaksiCollection.get();
      
      List<DetailTransaksiModel> matchingDetails = detailSnapshot.docs
          .map((doc) => DetailTransaksiModel.fromSnapshot(doc))
          .where((detail) => detail.namaBarang.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      // Get unique transaksi IDs
      Set<String> transaksiIds = matchingDetails.map((d) => d.idTransaksi).toSet();
      
      // Get transaksi documents
      List<TransaksiModel> transaksiList = [];
      for (String id in transaksiIds) {
        TransaksiModel? transaksi = await getTransaksiById(id);
        if (transaksi != null) {
          transaksiList.add(transaksi);
        }
      }
      
      // Sort by date descending
      transaksiList.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      
      return transaksiList;
    } catch (e) {
      throw Exception('Gagal mencari transaksi: ${e.toString()}');
    }
  }

  // Get total penjualan by date range
  Future<double> getTotalPenjualan(DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot snapshot = await _transaksiCollection
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();
      
      double total = 0;
      for (var doc in snapshot.docs) {
        TransaksiModel transaksi = TransaksiModel.fromSnapshot(doc);
        total += transaksi.totalHarga;
      }
      
      return total;
    } catch (e) {
      throw Exception('Gagal menghitung total penjualan: ${e.toString()}');
    }
  }
}
