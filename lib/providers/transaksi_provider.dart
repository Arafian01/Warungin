import 'package:flutter/material.dart';
import '../models/transaksi_model.dart';
import '../models/detail_transaksi_model.dart';
import '../services/transaksi_service.dart';
import '../services/data_sync_service.dart';

class TransaksiProvider with ChangeNotifier {
  final TransaksiService _transaksiService = TransaksiService();
  DataSyncService? _dataSyncService;
  
  List<TransaksiModel> _transaksiList = [];
  List<DetailTransaksiModel> _currentDetails = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TransaksiModel> get transaksiList => _transaksiList;
  List<DetailTransaksiModel> get currentDetails => _currentDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize and load data from local storage
  Future<void> loadFromLocal() async {
    _dataSyncService ??= await DataSyncService.getInstance();
    _transaksiList = _dataSyncService!.getTransaksiFromLocal();
    _currentDetails = _dataSyncService!.getDetailTransaksiFromLocal();
    notifyListeners();
  }

  // Get transaksi stream
  Stream<List<TransaksiModel>> getTransaksiStream() {
    return _transaksiService.getTransaksiStream();
  }

  // Get transaksi by date range stream
  Stream<List<TransaksiModel>> getTransaksiByDateRangeStream(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transaksiService.getTransaksiByDateRangeStream(startDate, endDate);
  }

  // Create transaksi
  Future<bool> createTransaksi(
    TransaksiModel transaksi,
    List<DetailTransaksiModel> details,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _transaksiService.createTransaksi(transaksi, details);
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

  // Get detail transaksi
  Future<void> loadDetailTransaksi(String idTransaksi) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentDetails = await _transaksiService.getDetailTransaksi(idTransaksi);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete transaksi
  Future<bool> deleteTransaksi(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _transaksiService.deleteTransaksi(id);
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

  // Search transaksi by item
  Future<void> searchTransaksiByItem(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transaksiList = await _transaksiService.searchTransaksiByItem(query);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get total penjualan
  Future<double> getTotalPenjualan(DateTime startDate, DateTime endDate) async {
    try {
      return await _transaksiService.getTotalPenjualan(startDate, endDate);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return 0;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear current details
  void clearCurrentDetails() {
    _currentDetails = [];
    notifyListeners();
  }
}
