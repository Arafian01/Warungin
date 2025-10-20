import 'package:flutter/material.dart';
import '../models/kategori_model.dart';
import '../services/kategori_service.dart';

class KategoriProvider with ChangeNotifier {
  final KategoriService _kategoriService = KategoriService();
  
  List<KategoriModel> _kategoriList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KategoriModel> get kategoriList => _kategoriList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get kategori stream
  Stream<List<KategoriModel>> getKategoriStream() {
    return _kategoriService.getKategoriStream();
  }

  // Create kategori
  Future<bool> createKategori(KategoriModel kategori) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _kategoriService.createKategori(kategori);
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

  // Update kategori
  Future<bool> updateKategori(String id, KategoriModel kategori) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _kategoriService.updateKategori(id, kategori);
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

  // Delete kategori
  Future<bool> deleteKategori(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _kategoriService.deleteKategori(id);
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

  // Search kategori
  Future<void> searchKategori(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _kategoriList = await _kategoriService.searchKategori(query);
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
