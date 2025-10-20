import 'package:flutter/material.dart';
import '../models/barang_model.dart';
import '../services/barang_service.dart';

class BarangProvider with ChangeNotifier {
  final BarangService _barangService = BarangService();
  
  List<BarangModel> _barangList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BarangModel> get barangList => _barangList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get barang stream
  Stream<List<BarangModel>> getBarangStream() {
    return _barangService.getBarangStream();
  }

  // Get barang by kategori stream
  Stream<List<BarangModel>> getBarangByKategoriStream(String idKategori) {
    return _barangService.getBarangByKategoriStream(idKategori);
  }

  // Create barang
  Future<bool> createBarang(BarangModel barang) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _barangService.createBarang(barang);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update barang
  Future<bool> updateBarang(String id, BarangModel barang) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _barangService.updateBarang(id, barang);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete barang
  Future<bool> deleteBarang(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _barangService.deleteBarang(id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search barang
  Future<void> searchBarang(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _barangList = await _barangService.searchBarang(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
