import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/kategori_model.dart';
import '../models/barang_model.dart';
import '../models/barang_satuan_model.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';

class LocalStorageService {
  static const String _keyKategori = 'cached_kategori';
  static const String _keyBarang = 'cached_barang';
  static const String _keyBarangSatuan = 'cached_barang_satuan';
  static const String _keyTransaksi = 'cached_transaksi';
  static const String _keyDetailTransaksi = 'cached_detail_transaksi';
  static const String _keyLastSync = 'last_sync_time';
  static const String _keyHasData = 'has_cached_data';

  // Singleton pattern
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // ==================== CHECK DATA ====================
  
  bool hasData() {
    return _preferences?.getBool(_keyHasData) ?? false;
  }

  DateTime? getLastSyncTime() {
    final timestamp = _preferences?.getInt(_keyLastSync);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  // ==================== KATEGORI ====================
  
  Future<void> saveKategoriList(List<KategoriModel> kategoriList) async {
    final jsonList = kategoriList.map((k) => {
      'id': k.id,
      'nama_kategori': k.namaKategori,
      'deskripsi': k.deskripsi,
      'created_at': k.createdAt?.millisecondsSinceEpoch,
    }).toList();
    
    await _preferences?.setString(_keyKategori, jsonEncode(jsonList));
    await _updateHasData();
  }

  List<KategoriModel> getKategoriList() {
    final jsonString = _preferences?.getString(_keyKategori);
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => KategoriModel(
      id: json['id'],
      namaKategori: json['nama_kategori'] ?? '',
      deskripsi: json['deskripsi'],
      createdAt: json['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : null,
    )).toList();
  }

  // ==================== BARANG ====================
  
  Future<void> saveBarangList(List<BarangModel> barangList) async {
    final jsonList = barangList.map((b) => {
      'id': b.id,
      'id_kategori': b.idKategori,
      'nama_barang': b.namaBarang,
      'created_at': b.createdAt?.millisecondsSinceEpoch,
    }).toList();
    
    await _preferences?.setString(_keyBarang, jsonEncode(jsonList));
    await _updateHasData();
  }

  List<BarangModel> getBarangList() {
    final jsonString = _preferences?.getString(_keyBarang);
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => BarangModel(
      id: json['id'],
      idKategori: json['id_kategori'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : null,
    )).toList();
  }

  // ==================== BARANG SATUAN ====================
  
  Future<void> saveBarangSatuanList(List<BarangSatuanModel> barangSatuanList) async {
    final jsonList = barangSatuanList.map((bs) => {
      'id': bs.id,
      'id_barang': bs.idBarang,
      'nama_satuan': bs.namaSatuan,
      'harga_jual': bs.hargaJual,
      'created_at': bs.createdAt?.millisecondsSinceEpoch,
    }).toList();
    
    await _preferences?.setString(_keyBarangSatuan, jsonEncode(jsonList));
    await _updateHasData();
  }

  List<BarangSatuanModel> getBarangSatuanList() {
    final jsonString = _preferences?.getString(_keyBarangSatuan);
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => BarangSatuanModel(
      id: json['id'],
      idBarang: json['id_barang'] ?? '',
      namaSatuan: json['nama_satuan'] ?? '',
      hargaJual: (json['harga_jual'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : null,
    )).toList();
  }

  // ==================== TRANSAKSI ====================
  
  Future<void> saveTransaksiList(List<TransaksiModel> transaksiList) async {
    final jsonList = transaksiList.map((t) => {
      'id': t.id,
      'total_harga': t.totalHarga,
      'tanggal': t.tanggal.millisecondsSinceEpoch,
      'catatan': t.catatan,
      'created_at': t.createdAt?.millisecondsSinceEpoch,
    }).toList();
    
    await _preferences?.setString(_keyTransaksi, jsonEncode(jsonList));
    await _updateHasData();
  }

  List<TransaksiModel> getTransaksiList() {
    final jsonString = _preferences?.getString(_keyTransaksi);
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => TransaksiModel(
      id: json['id'],
      totalHarga: (json['total_harga'] ?? 0).toDouble(),
      tanggal: DateTime.fromMillisecondsSinceEpoch(json['tanggal']),
      catatan: json['catatan'],
      createdAt: json['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : null,
    )).toList();
  }

  // ==================== DETAIL TRANSAKSI ====================
  
  Future<void> saveDetailTransaksiList(List<DetailTransaksiModel> detailList) async {
    final jsonList = detailList.map((dt) => {
      'id': dt.id,
      'id_transaksi': dt.idTransaksi,
      'id_barang_satuan': dt.idBarangSatuan,
      'id_barang': dt.idBarang,
      'nama_barang': dt.namaBarang,
      'jumlah': dt.jumlah,
      'created_at': dt.createdAt?.millisecondsSinceEpoch,
    }).toList();
    
    await _preferences?.setString(_keyDetailTransaksi, jsonEncode(jsonList));
    await _updateHasData();
  }

  List<DetailTransaksiModel> getDetailTransaksiList() {
    final jsonString = _preferences?.getString(_keyDetailTransaksi);
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => DetailTransaksiModel(
      id: json['id'],
      idTransaksi: json['id_transaksi'] ?? '',
      idBarangSatuan: json['id_barang_satuan'] ?? '',
      idBarang: json['id_barang'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : null,
    )).toList();
  }

  // ==================== UTILITY ====================
  
  Future<void> _updateHasData() async {
    await _preferences?.setBool(_keyHasData, true);
    await _preferences?.setInt(_keyLastSync, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> clearAllData() async {
    await _preferences?.remove(_keyKategori);
    await _preferences?.remove(_keyBarang);
    await _preferences?.remove(_keyBarangSatuan);
    await _preferences?.remove(_keyTransaksi);
    await _preferences?.remove(_keyDetailTransaksi);
    await _preferences?.remove(_keyLastSync);
    await _preferences?.setBool(_keyHasData, false);
  }
}
