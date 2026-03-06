/// Điểm dữ liệu cho biểu đồ (tránh import fl_chart vào model).
class ChartSpot {
  final double x;
  final double y;

  const ChartSpot(this.x, this.y);
}

/// Dữ liệu cho SpendingChart: tổng chi, tổng thu, đường chi, đường thu, đường tham chiếu.
class ChartDataModel {
  final double totalExpense;
  final double totalIncome;
  final List<ChartSpot> expenseSpots;
  final List<ChartSpot> incomeSpots;
  final List<ChartSpot> expenseAverageSpots;
  final List<ChartSpot> incomeAverageSpots;
  final String? labelStart;
  final String? labelEnd;
  final Map<double, String>? bottomLabels;

  const ChartDataModel({
    required this.totalExpense,
    required this.totalIncome,
    required this.expenseSpots,
    required this.incomeSpots,
    required this.expenseAverageSpots,
    required this.incomeAverageSpots,
    this.labelStart,
    this.labelEnd,
    this.bottomLabels,
  });
}
