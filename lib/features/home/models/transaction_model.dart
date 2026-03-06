import 'package:flutter/material.dart';

class TransactionModel {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;
  /// Danh mục chi tiêu (dùng để nhóm trong Top Spending).
  final String category;

  TransactionModel({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.category = 'Khác',
  });
}
