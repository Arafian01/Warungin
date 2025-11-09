import 'package:flutter/material.dart';
import '../models/barang_satuan_model.dart';
import '../services/barang_satuan_service.dart';
import '../services/data_sync_service.dart';

class BarangSatuanProvider with ChangeNotifier {
  final BarangSatuanService _service = BarangSatuanService();
  DataSyncService? _dataSyncService;

  List<BarangSatuanModel> _barangSatuanList = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentBarangId; // Track current barang being viewed

  List<BarangSatuanModel> get barangSatuanList => _barangSatuanList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentBarangId => _currentBarangId;

  // Initialize and load data from local storage
  Future<void> loadFromLocal() async {
    _dataSyncService ??= await DataSyncService.getInstance();
    _barangSatuanList = _dataSyncService!.getBarangSatuanFromLocal();
    notifyListeners();
  }

  // Create barang satuan
  Future<bool> createBarangSatuan(BarangSatuanModel barangSatuan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = await _service.createBarangSatuan(barangSatuan);
      _isLoading = false;
      
      if (id != null) {
        // Refresh the current barang's satuan list if we're viewing one
        if (_currentBarangId != null) {
          loadBarangSatuanByBarangId(_currentBarangId!);
        }
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
    _currentBarangId = null; // Clear current barang filter
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
    _barangSatuanList.clear(); // Clear previous data
    _currentBarangId = idBarang; // Set current barang filter
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
        // Refresh the current barang's satuan list if we're viewing one
        if (_currentBarangId != null) {
          loadBarangSatuanByBarangId(_currentBarangId!);
        }
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
        // Refresh the current barang's satuan list if we're viewing one
        if (_currentBarangId != null) {
          loadBarangSatuanByBarangId(_currentBarangId!);
        }
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
      // If we have a current barang filter, reload that instead of all
      if (_currentBarangId != null) {
        loadBarangSatuanByBarangId(_currentBarangId!);
      } else {
        loadAllBarangSatuan();
      }
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

  // Clear current data and filter (useful when navigating away)
  void clearData() {
    _barangSatuanList.clear();
    _currentBarangId = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
