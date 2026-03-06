import 'package:frontend/features/home/models/transaction_model.dart';

/// Trích xuất số từ chuỗi tiền (bỏ dấu phẩy, "₫", khoảng trắng).
/// Ví dụ: "13,482,000" -> 13482000, "30,000 ₫" -> 30000.
double parseAmountFromString(String amount) {
  final cleaned = amount.replaceAll(RegExp(r'[^\d]'), '');
  return double.tryParse(cleaned) ?? 0;
}

/// Trích xuất [day, month, year] từ chuỗi "d tháng m yyyy".
/// Trả về null nếu không parse được.
List<int>? parseDateParts(String dateStr) {
  final match = RegExp(r'(\d+)\s+tháng\s+(\d+)\s+(\d+)').firstMatch(dateStr);
  if (match == null) return null;
  final day = int.tryParse(match.group(1) ?? '');
  final month = int.tryParse(match.group(2) ?? '');
  final year = int.tryParse(match.group(3) ?? '');
  if (day == null || month == null || year == null) return null;
  return [day, month, year];
}

/// Ngày trong tháng (1-31) từ [day, month, year], hoặc null.
int? dayOfMonthFromTransaction(TransactionModel t) {
  final parts = parseDateParts(t.date);
  return parts != null && parts.isNotEmpty ? parts[0] : null;
}

/// Tháng (1-12) từ transaction.
int? monthFromTransaction(TransactionModel t) {
  final parts = parseDateParts(t.date);
  return parts != null && parts.length >= 2 ? parts[1] : null;
}

/// Năm từ transaction.
int? yearFromTransaction(TransactionModel t) {
  final parts = parseDateParts(t.date);
  return parts != null && parts.length >= 3 ? parts[2] : null;
}

/// Trả về [DateTime] (00:00:00) của giao dịch, hoặc null nếu không parse được.
DateTime? dateFromTransaction(TransactionModel t) {
  final parts = parseDateParts(t.date);
  if (parts == null || parts.length < 3) return null;
  final day = parts[0];
  final month = parts[1];
  final year = parts[2];
  if (day < 1 || day > 31 || month < 1 || month > 12) return null;
  return DateTime(year, month, day);
}

/// So sánh ngày: trả về > 0 nếu a mới hơn b (để sort giảm dần = mới nhất trước).
int _dateCompare(TransactionModel a, TransactionModel b) {
  final pa = parseDateParts(a.date);
  final pb = parseDateParts(b.date);
  if (pa == null || pb == null) return 0;
  // [day, month, year] -> so sánh year, month, day
  int c = (pb[2] - pa[2]);
  if (c != 0) return c;
  c = pb[1] - pa[1];
  if (c != 0) return c;
  return pb[0] - pa[0];
}

/// Lấy [limit] giao dịch gần đây nhất (sắp theo ngày mới → cũ).
List<TransactionModel> recentTransactions(List<TransactionModel> list, int limit) {
  if (list.isEmpty || limit <= 0) return [];
  final sorted = List<TransactionModel>.from(list)..sort(_dateCompare);
  return sorted.take(limit).toList();
}

/// Trả về bản sao danh sách giao dịch đã sắp theo thời gian giảm dần (mới nhất trước).
List<TransactionModel> transactionsSortedByDateDescending(List<TransactionModel> list) {
  final copy = List<TransactionModel>.from(list);
  copy.sort(_dateCompare);
  return copy;
}
