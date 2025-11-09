import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/data_sync_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  DataSyncService? _dataSyncService;
  
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSyncing = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isSyncing => _isSyncing;
  
  // Initialize DataSyncService
  Future<void> _initDataSyncService() async {
    _dataSyncService ??= await DataSyncService.getInstance();
  }

  // Listen to auth state changes
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.signInWithEmailPassword(email, password);
      
      if (_user != null) {
        // Sync data after successful login
        await _initDataSyncService();
        _isSyncing = true;
        notifyListeners();
        
        try {
          await _dataSyncService!.syncAllData();
        } catch (e) {
          // Log error but don't fail login
          debugPrint('Error syncing data: $e');
        }
        
        _isSyncing = false;
      }
      
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _isSyncing = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String email, String password, String displayName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.registerWithEmailPassword(email, password, displayName);
      
      if (_user != null) {
        // Sync data after successful registration
        await _initDataSyncService();
        _isSyncing = true;
        notifyListeners();
        
        try {
          await _dataSyncService!.syncAllData();
        } catch (e) {
          debugPrint('Error syncing data: $e');
        }
        
        _isSyncing = false;
      }
      
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _isSyncing = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      
      // Clear local data
      await _initDataSyncService();
      await _dataSyncService!.clearAllData();
      
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load user data
  Future<void> loadUserData(String uid) async {
    try {
      _user = await _authService.getUserData(uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
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

  // Sync data manually
  Future<bool> syncData() async {
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _initDataSyncService();
      await _dataSyncService!.syncAllData();
      _isSyncing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSyncing = false;
      notifyListeners();
      return false;
    }
  }

  // Check if has local data
  Future<bool> hasLocalData() async {
    await _initDataSyncService();
    return _dataSyncService!.hasLocalData();
  }

  // Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    await _initDataSyncService();
    return _dataSyncService!.getLastSyncTime();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
