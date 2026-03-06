import 'package:flutter/material.dart';

/// Màu nền dùng chung để phân tách đề mục và nội dung.
class AppColors {
  AppColors._();

  /// Nền card/block bên ngoài (khung)
  static const Color cardSurface = Color(0xFF1C1C1E);

  /// Nền phần đề mục (header) — xám nhạt hơn, nổi hơn
  static const Color sectionHeader = Color(0xFF2A2A2E);

  /// Nền phần nội dung / danh sách — đen hơn, tạo tương phản nhẹ
  static const Color sectionContent = Color(0xFF141416);
}
