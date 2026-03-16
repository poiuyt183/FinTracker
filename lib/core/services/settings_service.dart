import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  /// Reads the `currency` field from the current user's Firestore document.
  static Future<String?> getCurrency() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      if (data == null) return null;
      final currency = data['currency'];
      if (currency == null) return null;
      return currency as String;
    } catch (_) {
      return null;
    }
  }

  /// Writes the given currency code to the current user's Firestore document.
  static Future<void> setCurrency(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No authenticated user');
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'currency': code,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Clears the currency field in Firestore (useful for tests/logouts).
  static Future<void> clearCurrency() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'currency': null,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
