import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';

/// Dữ liệu báo cáo một tháng.
class MonthReportData {
  final int month;
  final int year;
  final double totalIncome;
  final double totalExpense;
  final List<TransactionModel> transactions;

  const MonthReportData({
    required this.month,
    required this.year,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  });

  String get monthYearLabel {
    return 'Tháng $month/$year';
  }
}

/// Lấy danh sách 12 tháng gần nhất (từ tháng hiện tại lùi dần).
List<DateTime> last12MonthsFromNow() {
  final now = DateTime.now();
  final list = <DateTime>[];
  for (int i = 0; i < 12; i++) {
    list.add(DateTime(now.year, now.month - i, 1));
  }
  return list;
}

/// Lọc giao dịch thuộc tháng [month], năm [year].
List<TransactionModel> transactionsInMonth(
  List<TransactionModel> all,
  int month,
  int year,
) {
  return all.where((t) {
    final m = monthFromTransaction(t);
    final y = yearFromTransaction(t);
    return m == month && y == year;
  }).toList();
}

/// Lọc giao dịch trong [days] ngày gần nhất (kể từ đầu ngày hôm nay).
List<TransactionModel> transactionsInLastDays(
  List<TransactionModel> all,
  int days,
) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
  final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  return all.where((t) {
    final dt = dateFromTransaction(t);
    if (dt == null) return false;
    return !dt.isBefore(start) && !dt.isAfter(endOfToday);
  }).toList();
}

/// Tạo dữ liệu báo cáo 12 tháng từ [transactions].
List<MonthReportData> buildMonthlyReport(List<TransactionModel> transactions) {
  final months = last12MonthsFromNow();
  return months.map((date) {
    final list = transactionsInMonth(transactions, date.month, date.year);
    double income = 0;
    double expense = 0;
    for (final t in list) {
      final amount = parseAmountFromString(t.amount);
      if (t.isIncome) {
        income += amount;
      } else {
        expense += amount;
      }
    }
    return MonthReportData(
      month: date.month,
      year: date.year,
      totalIncome: income,
      totalExpense: expense,
      transactions: list,
    );
  }).toList();
}
