import 'package:flutter/material.dart';

class WalletModel {
  final IconData icon;
  final Color color;
  final String title;
  final String amount;

  const WalletModel({
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
  });
}
