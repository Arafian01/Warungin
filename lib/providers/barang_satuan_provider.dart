import 'package:flutter/material.dart';
import '../models/barang_satuan_model.dart';
import '../services/barang_satuan_service.dart';

class BarangSatuanProvider with ChangeNotifier {
  final BarangSatuanService _service = BarangSatuanService();

  List<BarangSatuanModel> _barangSatuanList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BarangSatuanModel> get barangSatuanList => _barangSatuanList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create barang satuan
  Future<bool> createBarangSatuan(BarangSatuanModel barangSatuan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = await _service.createBarangSatuan(barangSatuan);
      _isLoading = false;
      
      if (id != null) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Gagal menambahkan satuan barang';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Load all barang satuan
  void loadAllBarangSatuan() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _service.getAllBarangSatuan().listen(
      (list) {
        _barangSatuanList = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error loading data: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load barang satuan by barang ID
  void loadBarangSatuanByBarangId(String idBarang) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _service.getBarangSatuanByBarangId(idBarang).listen(
      (list) {
        _barangSatuanList = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error loading data: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Get barang satuan by ID
  Future<BarangSatuanModel?> getBarangSatuanById(String id) async {
    try {
      return await _service.getBarangSatuanById(id);
    } catch (e) {
      _errorMessage = 'Error: $e';
      notifyListeners();
      return null;
    }
  }

  // Update barang satuan
  Future<bool> updateBarangSatuan(String id, BarangSatuanModel barangSatuan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.updateBarangSatuan(id, barangSatuan);
      _isLoading = false;
      
      if (success) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Gagal mengupdate satuan barang';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete barang satuan
  Future<bool> deleteBarangSatuan(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.deleteBarangSatuan(id);
      _isLoading = false;
      
      if (success) {
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Gagal menghapus satuan barang';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete all barang satuan for a barang
  Future<bool> deleteBarangSatuanByBarangId(String idBarang) async {
    try {
      return await _service.deleteBarangSatuanByBarangId(idBarang);
    } catch (e) {
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  // Check if barang has satuan
  Future<bool> hasBarangSatuan(String idBarang) async {
    try {
      return await _service.hasBarangSatuan(idBarang);
    } catch (e) {
      return false;
    }
  }

  // Get barang satuan count
  Future<int> getBarangSatuanCount(String idBarang) async {
    try {
      return await _service.getBarangSatuanCount(idBarang);
    } catch (e) {
      return 0;
    }
  }

  // Search barang satuan
  void searchBarangSatuan(String query) {
    if (query.isEmpty) {
      loadAllBarangSatuan();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _service.searchBarangSatuan(query).listen(
      (list) {
        _barangSatuanList = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error searching: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
