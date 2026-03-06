import 'package:flutter/material.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/models/category_spending_model.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';

/// Gán icon và màu theo tên category (mặc định nếu không có trong map).
final Map<String, (IconData, Color)> _categoryStyle = {
  'Ăn uống': (Icons.restaurant, Colors.orange),
  'Di chuyển': (Icons.directions_car, Colors.blue),
  'Mua sắm': (Icons.shopping_bag, Colors.purple),
  'Sức khỏe': (Icons.medical_services, Colors.red),
  'Giải trí': (Icons.movie, Colors.amber),
  'Quà tặng': (Icons.card_giftcard, Colors.pink),
  'Siêu thị': (Icons.shopping_cart, Colors.teal),
  'Công nghệ': (Icons.phone_android, Colors.cyan),
  'Chuyển khoản': (Icons.account_balance_wallet, Colors.teal),
  'Lương': (Icons.work, Colors.green),
  'Thu nợ': (Icons.payments, Colors.indigo),
  'Khác': (Icons.category, Colors.grey),
};

(IconData, Color) _styleForCategory(String category) {
  return _categoryStyle[category] ?? _categoryStyle['Khác']!;
}

/// Kết quả tính Top Spending từ transactions.
class CategorySpendingResult {
  final List<CategorySpendingModel> items;
  final Map<String, List<TransactionModel>> categoryTransactions;

  const CategorySpendingResult({
    required this.items,
    required this.categoryTransactions,
  });
}

/// Tính Top Spending theo category từ danh sách giao dịch (chỉ lấy giao dịch chi).
/// [periodMonth], [periodYear]: nếu truyền thì chỉ lấy giao dịch trong tháng đó; null = lấy tất cả.
CategorySpendingResult buildCategorySpendingFromTransactions(
  List<TransactionModel> transactions, {
  int? periodMonth,
  int? periodYear,
}) {
  final expenses = transactions.where((t) => !t.isIncome).toList();
  if (periodMonth != null && periodYear != null) {
    expenses.removeWhere((t) {
      final m = monthFromTransaction(t);
      final y = yearFromTransaction(t);
      return m != periodMonth || y != periodYear;
    });
  }

  final Map<String, double> categoryTotal = {};
  final Map<String, List<TransactionModel>> categoryTransactions = {};

  for (final t in expenses) {
    final cat = t.category.isEmpty ? 'Khác' : t.category;
    final amount = parseAmountFromString(t.amount);
    categoryTotal[cat] = (categoryTotal[cat] ?? 0) + amount;
    categoryTransactions.putIfAbsent(cat, () => []).add(t);
  }

  final totalExpense = categoryTotal.values.fold<double>(0, (a, b) => a + b);
  final items = <CategorySpendingModel>[];

  final sortedCategories = categoryTotal.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (final e in sortedCategories) {
    final cat = e.key;
    final sum = e.value;
    final pct = totalExpense > 0 ? (sum / totalExpense * 100) : 0.0;
    final (icon, color) = _styleForCategory(cat);
    items.add(CategorySpendingModel(
      icon: icon,
      color: color,
      categoryName: cat,
      amount: formatCurrency(sum, currency: '₫', decimalDigits: 0),
      percentage: pct,
    ));
  }

  return CategorySpendingResult(
    items: items,
    categoryTransactions: categoryTransactions,
  );
}
