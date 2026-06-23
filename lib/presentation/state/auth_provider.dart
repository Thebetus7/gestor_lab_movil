import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _profile;
  bool _isCheckingAuth = true;
  bool _isConnected = false;
  bool _isCheckingConnection = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get profile => _profile;
  bool get isCheckingAuth => _isCheckingAuth;
  bool get isConnected => _isConnected;
  bool get isCheckingConnection => _isCheckingConnection;

  AuthProvider() {
    _checkAuth();
    checkConnection();
  }

  Future<void> _checkAuth() async {
    _isCheckingAuth = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('access_token') != null) {
        _isAuthenticated = true;
      }
    } catch (e) {
      _isAuthenticated = false;
    } finally {
      _isCheckingAuth = false;
      notifyListeners();
    }
  }

  Future<void> checkConnection() async {
    _isCheckingConnection = true;
    notifyListeners();
    try {
      _isConnected = await _authRepository.checkConnection();
    } catch (e) {
      _isConnected = false;
    } finally {
      _isCheckingConnection = false;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.login(username, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error de login. Revise sus credenciales.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      _profile = await _authRepository.getProfile();
      notifyListeners();
    } catch (e) {
      _error = 'Error obteniendo perfil';
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    _profile = null;
    notifyListeners();
  }
}
