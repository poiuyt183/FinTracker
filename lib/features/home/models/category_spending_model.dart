import 'package:flutter/material.dart';

/// Dữ liệu cho một nhóm chi tiêu (dùng trong TopSpending).
class CategorySpendingModel {
  final IconData icon;
  final Color color;
  final String categoryName;
  final String amount;
  final double percentage; // 0.0 - 100.0, phần trăm so tổng chi

  const CategorySpendingModel({
    required this.icon,
    required this.color,
    required this.categoryName,
    required this.amount,
    this.percentage = 0,
  });
}
