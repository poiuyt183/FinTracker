import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/features/auth/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  AuthProvider({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository() {
    // Initialize with current user if already logged in
    _user = _authRepository.currentUser;

    // Listen to auth state changes
    _authRepository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.signUpWithEmailPassword(
      email: email,
      password: password,
      name: name,
    );

    _setLoading(false);

    if (result['success']) {
      _user = result['user'];
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Sign in
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.signInWithEmailPassword(
      email: email,
      password: password,
    );

    _setLoading(false);

    if (result['success']) {
      _user = result['user'];
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    await _authRepository.signOut();
    _user = null;
    _setLoading(false);
    notifyListeners();
  }

  // Reset password
  Future<bool> resetPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.resetPassword(email: email);

    _setLoading(false);

    if (result['success']) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Update profile
  Future<bool> updateProfile({String? name, String? email}) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.updateProfile(
      name: name,
      email: email,
    );

    _setLoading(false);

    if (result['success']) {
      _user = _authRepository.currentUser;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Change password
  Future<bool> changePassword({required String newPassword}) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.changePassword(
      newPassword: newPassword,
    );

    _setLoading(false);

    if (result['success']) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.deleteAccount();

    _setLoading(false);

    if (result['success']) {
      _user = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['message'];
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
