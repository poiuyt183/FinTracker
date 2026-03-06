import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/chart_data_model.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';
import 'package:frontend/features/home/utils/chart_data_from_transactions.dart';

class SpendingChart extends StatefulWidget {
  final ChartDataModel data;
  final List<TransactionModel>? transactions;

  const SpendingChart({
    super.key,
    required this.data,
    this.transactions,
  });

  @override
  State<SpendingChart> createState() => _SpendingChartState();
}

class _SpendingChartState extends State<SpendingChart> {
  int _selectedTab = 0; // 0 = Chi, 1 = Thu
  int _periodMonths = 1; // 1 tháng | 3 tháng

  /// Điểm đầu = (hôm nay - 1 hoặc 3 tháng), điểm cuối = hôm nay.
  ChartDataModel get _effectiveData {
    if (widget.transactions != null) {
      final days = _periodMonths == 3 ? 90 : 30;
      return chartDataFromTransactionsDateRange(widget.transactions!, days: days);
    }
    return widget.data;
  }

  int get _periodDays => _periodMonths == 3 ? 90 : 30;

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final chartData = _effectiveData;
    final isExpense = _selectedTab == 0;
    final spots = isExpense
        ? chartData.expenseSpots.map((s) => FlSpot(s.x, s.y)).toList()
        : chartData.incomeSpots.map((s) => FlSpot(s.x, s.y)).toList();
    final averageSpots = isExpense
        ? chartData.expenseAverageSpots.map((s) => FlSpot(s.x, s.y)).toList()
        : chartData.incomeAverageSpots.map((s) => FlSpot(s.x, s.y)).toList();
    final totalValue = isExpense ? chartData.totalExpense : chartData.totalIncome;
    final lineColor = isExpense ? p.expenseColor : p.incomeColor;
    final label = isExpense ? 'total_spent'.tr() : 'total_earned'.tr();

    final allY = spots.map((s) => s.y).toList();
    final double dataMaxY = allY.isEmpty ? 1.0 : allY.reduce((a, b) => a > b ? a : b);
    const double minY = 0;
    final double maxY = dataMaxY <= 0 ? 1.0 : (dataMaxY * 1.25 + 0.2);

    final hasPeriodChoice = widget.transactions != null && widget.transactions!.isNotEmpty;
    final days = _periodDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0 ? p.expenseColor.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'expense'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedTab == 0 ? p.expenseColor : p.subtitleText,
                      fontWeight: _selectedTab == 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1 ? p.incomeColor.withValues(alpha: 0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'income'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedTab == 1 ? p.incomeColor : p.subtitleText,
                      fontWeight: _selectedTab == 1 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '$label: ${formatCurrency(totalValue, currency: '₫', decimalDigits: 0)}',
          style: TextStyle(color: lineColor, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: hasPeriodChoice ? days.toDouble() : (chartData.expenseSpots.isEmpty ? 28.0 : chartData.expenseSpots.last.x),
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: p.chartGridLine,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (maxY - minY) / 4,
                    getTitlesWidget: (value, meta) {
                      if (value >= minY && value <= maxY) {
                        final label = value == value.truncateToDouble()
                            ? '${value.toInt()}'
                            : value.toStringAsFixed(1);
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            '$label tr',
                            style: TextStyle(color: p.subtitleText, fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    reservedSize: 28,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final labels = chartData.bottomLabels;
                      if (labels != null && labels.containsKey(value)) {
                        return Text(
                          labels[value]!,
                          style: TextStyle(color: p.subtitleText, fontSize: 10),
                        );
                      }
                      if (labels == null) {
                        if (value == (spots.isNotEmpty ? spots.first.x : 0)) {
                          return Text(
                            chartData.labelStart ?? "01/02",
                            style: TextStyle(color: p.subtitleText, fontSize: 10),
                          );
                        }
                        if (spots.isNotEmpty && value == spots.last.x) {
                          return Text(
                            chartData.labelEnd ?? "28/02",
                            style: TextStyle(color: p.subtitleText, fontSize: 10),
                          );
                        }
                      }
                      return const SizedBox();
                    },
                    reservedSize: 24,
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: lineColor,
                  barWidth: 2.5,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: lineColor,
                        strokeWidth: 1,
                        strokeColor: lineColor.withValues(alpha: 0.5),
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor.withValues(alpha: 0.2),
                        lineColor.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: averageSpots,
                  isCurved: false,
                  color: p.chartAverageLine,
                  barWidth: 2,
                  dashArray: const [5, 5],
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        if (hasPeriodChoice) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PeriodChip(
                  label: 'one_month'.tr(),
                  selected: _periodMonths == 1,
                  onTap: () => setState(() => _periodMonths = 1),
                  palette: p,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PeriodChip(
                  label: 'three_months'.tr(),
                  selected: _periodMonths == 3,
                  onTap: () => setState(() => _periodMonths = 3),
                  palette: p,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final PaletteColors palette;

  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? palette.primaryAction.withValues(alpha: 0.15) : palette.leadingIconBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? palette.primaryAction : palette.borderColor.withValues(alpha: 0.5),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? palette.primaryAction : palette.subtitleText,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
