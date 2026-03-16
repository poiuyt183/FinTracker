import 'package:flutter/material.dart';
import '../../auth/viewmodel/auth_provider.dart';

class AccountViewModel extends ChangeNotifier {
  final AuthProvider authProvider;
  AccountViewModel(this.authProvider);

  bool get isLoading => authProvider.isLoading;
  String? get errorMessage => authProvider.errorMessage;

  Future<bool> updateProfile({String? name, String? email}) async {
    return await authProvider.updateProfile(name: name, email: email);
  }

  Future<bool> changePassword(String newPassword) async {
    return await authProvider.changePassword(newPassword: newPassword);
  }

  Future<bool> deleteAccount() async {
    return await authProvider.deleteAccount();
  }

  Future<void> logout() async {
    await authProvider.signOut();
  }
}
