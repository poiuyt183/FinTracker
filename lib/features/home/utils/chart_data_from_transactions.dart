import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/models/chart_data_model.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';

/// Chuyển danh sách giao dịch sang dữ liệu biểu đồ (tổng chi/thu + biến động theo ngày).
/// [transactions] — toàn bộ giao dịch (sẽ lọc theo [month]/[year] nếu truyền vào).
/// [month], [year] — nếu truyền thì chỉ lấy giao dịch trong tháng đó; không truyền thì dùng tháng của giao dịch đầu tiên hoặc tháng hiện tại.
/// [daysInMonth] — số ngày trong tháng (28/29/30/31) để build trục X.
ChartDataModel chartDataFromTransactions(
  List<TransactionModel> transactions, {
  int? month,
  int? year,
  int daysInMonth = 28,
}) {
  if (transactions.isEmpty) {
    return ChartDataModel(
      totalExpense: 0,
      totalIncome: 0,
      expenseSpots: const [ChartSpot(0, 0), ChartSpot(28, 0)],
      incomeSpots: const [ChartSpot(0, 0), ChartSpot(28, 0)],
      expenseAverageSpots: const [ChartSpot(0, 0), ChartSpot(28, 0)],
      incomeAverageSpots: const [ChartSpot(0, 0), ChartSpot(28, 0)],
      labelStart: '01',
      labelEnd: '$daysInMonth',
      bottomLabels: <double, String>{
        0: '01',
        7: '08',
        14: '15',
        21: '22',
        28: '28',
      },
    );
  }

  int filterMonth = month ?? monthFromTransaction(transactions.first) ?? DateTime.now().month;
  int filterYear = year ?? yearFromTransaction(transactions.first) ?? DateTime.now().year;

  final inMonth = transactions.where((t) {
    final m = monthFromTransaction(t);
    final y = yearFromTransaction(t);
    return m == filterMonth && y == filterYear;
  }).toList();

  double totalExpense = 0;
  double totalIncome = 0;
  final Map<int, double> dailyExpense = {};
  final Map<int, double> dailyIncome = {};

  for (final t in inMonth) {
    final amount = parseAmountFromString(t.amount);
    final day = dayOfMonthFromTransaction(t);
    if (t.isIncome) {
      totalIncome += amount;
      if (day != null && day >= 1 && day <= daysInMonth) {
        dailyIncome[day] = (dailyIncome[day] ?? 0) + amount;
      }
    } else {
      totalExpense += amount;
      if (day != null && day >= 1 && day <= daysInMonth) {
        dailyExpense[day] = (dailyExpense[day] ?? 0) + amount;
      }
    }
  }

  // Tích lũy chi theo ngày (đơn vị triệu VND)
  final List<ChartSpot> expenseSpots = [];
  double cumExp = 0;
  for (int d = 1; d <= daysInMonth; d++) {
    cumExp += dailyExpense[d] ?? 0;
    expenseSpots.add(ChartSpot((d - 1).toDouble(), cumExp / 1000000));
  }

  // Tích lũy thu theo ngày (đơn vị triệu VND)
  final List<ChartSpot> incomeSpots = [];
  double cumInc = 0;
  for (int d = 1; d <= daysInMonth; d++) {
    cumInc += dailyIncome[d] ?? 0;
    incomeSpots.add(ChartSpot((d - 1).toDouble(), cumInc / 1000000));
  }

  final expenseAverageSpots = [
    ChartSpot(0, 0),
    ChartSpot((daysInMonth - 1).toDouble(), totalExpense / 1000000),
  ];
  final incomeAverageSpots = [
    ChartSpot(0, 0),
    ChartSpot((daysInMonth - 1).toDouble(), totalIncome / 1000000),
  ];

  String pad(int d) => d.toString().padLeft(2, '0');
  final monthStr = pad(filterMonth);
  final days = daysInMonth;
  final bottomLabels = <double, String>{
    0: '${pad(1)}/$monthStr',
    7: '${pad(8)}/$monthStr',
    14: '${pad(15)}/$monthStr',
    21: '${pad(22)}/$monthStr',
    (days - 1).toDouble(): '${pad(days)}/$monthStr',
  };

  return ChartDataModel(
    totalExpense: totalExpense,
    totalIncome: totalIncome,
    expenseSpots: expenseSpots,
    incomeSpots: incomeSpots,
    expenseAverageSpots: expenseAverageSpots,
    incomeAverageSpots: incomeAverageSpots,
    labelStart: '01/$monthStr',
    labelEnd: '$daysInMonth/$monthStr',
    bottomLabels: bottomLabels,
  );
}

/// Trả về ChartDataModel cho [monthsCount] tháng gần nhất (1 hoặc 3).
/// Mỗi tháng một điểm trên trục X; tổng thu/chi theo tháng (đơn vị triệu VND).
ChartDataModel chartDataFromTransactionsByMonths(
  List<TransactionModel> transactions, {
  int monthsCount = 3,
}) {
  final now = DateTime.now();
  if (transactions.isEmpty || monthsCount <= 0) {
    final emptySpots = List.generate(monthsCount.clamp(1, 12), (i) => ChartSpot(i.toDouble(), 0));
    final labels = <double, String>{};
    for (int i = 0; i < monthsCount; i++) {
      final d = DateTime(now.year, now.month - (monthsCount - 1 - i), 1);
      labels[i.toDouble()] = 'T${d.month}';
    }
    return ChartDataModel(
      totalExpense: 0,
      totalIncome: 0,
      expenseSpots: emptySpots,
      incomeSpots: emptySpots,
      expenseAverageSpots: emptySpots,
      incomeAverageSpots: emptySpots,
      labelStart: 'T${now.month - monthsCount + 1}',
      labelEnd: 'T${now.month}',
      bottomLabels: labels,
    );
  }

  double totalExpense = 0;
  double totalIncome = 0;
  final List<ChartSpot> expenseSpots = [];
  final List<ChartSpot> incomeSpots = [];
  final Map<double, String> bottomLabels = {};

  for (int i = 0; i < monthsCount; i++) {
    final d = DateTime(now.year, now.month - (monthsCount - 1 - i), 1);
    final month = d.month;
    final year = d.year;
    final inMonth = transactions.where((t) {
      final m = monthFromTransaction(t);
      final y = yearFromTransaction(t);
      return m == month && y == year;
    }).toList();

    double mExp = 0;
    double mInc = 0;
    for (final t in inMonth) {
      final amount = parseAmountFromString(t.amount);
      if (t.isIncome) {
        mInc += amount;
      } else {
        mExp += amount;
      }
    }
    totalExpense += mExp;
    totalIncome += mInc;
    expenseSpots.add(ChartSpot(i.toDouble(), mExp / 1000000));
    incomeSpots.add(ChartSpot(i.toDouble(), mInc / 1000000));
    bottomLabels[i.toDouble()] = 'T${month}';
  }

  final maxE = expenseSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b);
  final maxI = incomeSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b);
  final expenseAverageSpots = [
    ChartSpot(0, 0),
    ChartSpot((monthsCount - 1).toDouble(), totalExpense / monthsCount / 1000000),
  ];
  final incomeAverageSpots = [
    ChartSpot(0, 0),
    ChartSpot((monthsCount - 1).toDouble(), totalIncome / monthsCount / 1000000),
  ];

  return ChartDataModel(
    totalExpense: totalExpense,
    totalIncome: totalIncome,
    expenseSpots: expenseSpots,
    incomeSpots: incomeSpots,
    expenseAverageSpots: expenseAverageSpots,
    incomeAverageSpots: incomeAverageSpots,
    labelStart: 'T${now.month - monthsCount + 1}',
    labelEnd: 'T${now.month}',
    bottomLabels: bottomLabels,
  );
}

/// Trục X: điểm đầu = [days] ngày trước, điểm cuối = hôm nay.
/// Dữ liệu tích lũy theo từng ngày trong khoảng đó (đơn vị triệu VND).
ChartDataModel chartDataFromTransactionsDateRange(
  List<TransactionModel> transactions, {
  int days = 30,
}) {
  final now = DateTime.now();
  final endDate = DateTime(now.year, now.month, now.day);
  final startDate = endDate.subtract(Duration(days: days));

  String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  if (transactions.isEmpty || days <= 0) {
    final emptySpots = [ChartSpot(0, 0), ChartSpot(days.toDouble(), 0)];
    final labels = <double, String>{
      0: fmt(startDate),
      days / 4: fmt(startDate.add(Duration(days: (days / 4).round()))),
      days / 2: fmt(startDate.add(Duration(days: (days / 2).round()))),
      (3 * days / 4): fmt(startDate.add(Duration(days: (3 * days / 4).round()))),
      days.toDouble(): fmt(endDate),
    };
    return ChartDataModel(
      totalExpense: 0,
      totalIncome: 0,
      expenseSpots: emptySpots,
      incomeSpots: emptySpots,
      expenseAverageSpots: emptySpots,
      incomeAverageSpots: emptySpots,
      labelStart: fmt(startDate),
      labelEnd: fmt(endDate),
      bottomLabels: labels,
    );
  }

  final Map<int, double> dailyExpense = {};
  final Map<int, double> dailyIncome = {};
  for (final t in transactions) {
    final dt = dateFromTransaction(t);
    if (dt == null) continue;
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d.isBefore(startDate) || d.isAfter(endDate)) continue;
    final dayIndex = d.difference(startDate).inDays;
    if (dayIndex < 0 || dayIndex > days) continue;
    final amount = parseAmountFromString(t.amount);
    if (t.isIncome) {
      dailyIncome[dayIndex] = (dailyIncome[dayIndex] ?? 0) + amount;
    } else {
      dailyExpense[dayIndex] = (dailyExpense[dayIndex] ?? 0) + amount;
    }
  }

  double totalExpense = 0;
  double totalIncome = 0;
  final List<ChartSpot> expenseSpots = [];
  final List<ChartSpot> incomeSpots = [];
  for (int i = 0; i <= days; i++) {
    totalExpense += dailyExpense[i] ?? 0;
    totalIncome += dailyIncome[i] ?? 0;
    expenseSpots.add(ChartSpot(i.toDouble(), totalExpense / 1000000));
    incomeSpots.add(ChartSpot(i.toDouble(), totalIncome / 1000000));
  }

  final expenseAverageSpots = [
    ChartSpot(0, 0),
    ChartSpot(days.toDouble(), totalExpense / 1000000),
  ];
  final incomeAverageSpots = [
    ChartSpot(0, 0),
    ChartSpot(days.toDouble(), totalIncome / 1000000),
  ];

  final bottomLabels = <double, String>{
    0: fmt(startDate),
    days.toDouble(): fmt(endDate),
  };
  final step = days ~/ 4;
  if (step > 0) {
    for (int k = 1; k <= 3; k++) {
      final x = (k * step).toDouble();
      bottomLabels[x] = fmt(startDate.add(Duration(days: k * step)));
    }
  }

  return ChartDataModel(
    totalExpense: totalExpense,
    totalIncome: totalIncome,
    expenseSpots: expenseSpots,
    incomeSpots: incomeSpots,
    expenseAverageSpots: expenseAverageSpots,
    incomeAverageSpots: incomeAverageSpots,
    labelStart: fmt(startDate),
    labelEnd: fmt(endDate),
    bottomLabels: bottomLabels,
  );
}
