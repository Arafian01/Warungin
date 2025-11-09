import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kategori_model.dart';
import '../models/barang_model.dart';
import '../models/barang_satuan_model.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';
import 'local_storage_service.dart';

class DataSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final LocalStorageService _localStorage;

  // Singleton pattern
  static DataSyncService? _instance;

  DataSyncService._();

  static Future<DataSyncService> getInstance() async {
    _instance ??= DataSyncService._();
    _instance!._localStorage = await LocalStorageService.getInstance();
    return _instance!;
  }

  // ==================== FETCH FROM FIREBASE ====================

  Future<List<KategoriModel>> _fetchKategoriFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('kategori')
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => KategoriModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data kategori: ${e.toString()}');
    }
  }

  Future<List<BarangModel>> _fetchBarangFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('barang')
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BarangModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data barang: ${e.toString()}');
    }
  }

  Future<List<BarangSatuanModel>> _fetchBarangSatuanFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('barang_satuan')
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BarangSatuanModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data barang satuan: ${e.toString()}');
    }
  }

  Future<List<TransaksiModel>> _fetchTransaksiFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('transaksi')
          .orderBy('tanggal', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransaksiModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data transaksi: ${e.toString()}');
    }
  }

  Future<List<DetailTransaksiModel>> _fetchDetailTransaksiFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('detail_transaksi')
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DetailTransaksiModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data detail transaksi: ${e.toString()}');
    }
  }

  // ==================== SYNC ALL DATA ====================

  /// Sync all data from Firebase to local storage
  /// Returns true if successful, throws exception on error
  Future<bool> syncAllData() async {
    try {
      // Fetch all data from Firebase
      final kategoriList = await _fetchKategoriFromFirebase();
      final barangList = await _fetchBarangFromFirebase();
      final barangSatuanList = await _fetchBarangSatuanFromFirebase();
      final transaksiList = await _fetchTransaksiFromFirebase();
      final detailTransaksiList = await _fetchDetailTransaksiFromFirebase();

      // Save to local storage
      await _localStorage.saveKategoriList(kategoriList);
      await _localStorage.saveBarangList(barangList);
      await _localStorage.saveBarangSatuanList(barangSatuanList);
      await _localStorage.saveTransaksiList(transaksiList);
      await _localStorage.saveDetailTransaksiList(detailTransaksiList);

      return true;
    } catch (e) {
      throw Exception('Gagal sinkronisasi data: ${e.toString()}');
    }
  }

  // ==================== LOAD FROM LOCAL STORAGE ====================

  List<KategoriModel> getKategoriFromLocal() {
    return _localStorage.getKategoriList();
  }

  List<BarangModel> getBarangFromLocal() {
    return _localStorage.getBarangList();
  }

  List<BarangSatuanModel> getBarangSatuanFromLocal() {
    return _localStorage.getBarangSatuanList();
  }

  List<TransaksiModel> getTransaksiFromLocal() {
    return _localStorage.getTransaksiList();
  }

  List<DetailTransaksiModel> getDetailTransaksiFromLocal() {
    return _localStorage.getDetailTransaksiList();
  }

  // ==================== UTILITY ====================

  bool hasLocalData() {
    return _localStorage.hasData();
  }

  DateTime? getLastSyncTime() {
    return _localStorage.getLastSyncTime();
  }

  Future<void> clearAllData() async {
    await _localStorage.clearAllData();
  }
}
