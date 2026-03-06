import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/utils/monthly_report_helper.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/view/widgets/transaction_item.dart';
import 'package:frontend/features/home/view/widgets/detail_screen_app_bar.dart';

class ReportDetailScreen extends StatefulWidget {
  final List<TransactionModel> transactions;

  const ReportDetailScreen({
    super.key,
    required this.transactions,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<MonthReportData> _report;

  @override
  void initState() {
    super.initState();
    _report = buildMonthlyReport(widget.transactions);
    _tabController = TabController(length: _report.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Quay về màn Home (màn trước).
  void _goBackToHome() => Navigator.maybePop(context);

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Scaffold(
      backgroundColor: p.backgroundColor,
      appBar: DetailScreenAppBar(
        title: 'report_detail'.tr(),
        onBack: _goBackToHome,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: p.primaryAction,
          unselectedLabelColor: p.subtitleText,
          indicatorColor: p.primaryAction,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          tabs: _report
              .map((m) => Tab(text: 'T${m.month}/${m.year.toString().substring(2)}'))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _report.map((monthData) => _buildMonthContent(context, monthData)).toList(),
      ),
    );
  }

  Widget _buildMonthContent(BuildContext context, MonthReportData monthData) {
    final p = paletteOf(context);
    final shadow = shadowColorOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Thu / Chi — hai card riêng, phong cách khác
          Row(
            children: [
              Expanded(
                child: _IncomeExpenseCard(
                  isIncome: true,
                  label: 'total_income'.tr(),
                  value: formatCurrency(monthData.totalIncome, currency: '₫', decimalDigits: 0),
                  palette: p,
                  shadow: shadow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _IncomeExpenseCard(
                  isIncome: false,
                  label: 'total_expense'.tr(),
                  value: formatCurrency(monthData.totalExpense, currency: '₫', decimalDigits: 0),
                  palette: p,
                  shadow: shadow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Tiêu đề danh sách giao dịch
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'transactions_in_month'.tr(),
              style: TextStyle(
                color: p.subtitleText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (monthData.transactions.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              decoration: BoxDecoration(
                color: p.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: p.borderColor.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: p.iconMuted),
                  const SizedBox(height: 16),
                  Text(
                    'no_transactions_this_month'.tr(),
                    style: TextStyle(color: p.subtitleText, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Builder(
              builder: (context) {
                final sorted = transactionsSortedByDateDescending(monthData.transactions);
                return Container(
                  decoration: BoxDecoration(
                    color: p.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: p.borderColor.withValues(alpha: 0.5)),
                    boxShadow: [BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < sorted.length; i++) ...[
                        TransactionItem.fromModel(
                          sorted[i],
                          onTap: () => _onTransactionTap(context, sorted[i]),
                        ),
                        if (i < sorted.length - 1)
                          Divider(height: 1, indent: 72, endIndent: 16, color: p.borderColor.withValues(alpha: 0.6)),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _onTransactionTap(BuildContext context, TransactionModel transaction) {
    final p = paletteOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: p.dialogBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: _TransactionDetailSheet(transaction: transaction, palette: p),
      )
    );
  }
}

class _IncomeExpenseCard extends StatelessWidget {
  final bool isIncome;
  final String label;
  final String value;
  final PaletteColors palette;
  final Color shadow;

  const _IncomeExpenseCard({
    required this.isIncome,
    required this.label,
    required this.value,
    required this.palette,
    required this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? palette.incomeColor : palette.expenseColor;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: palette.subtitleText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Nội dung bottom sheet chi tiết giao dịch — tách riêng để giảm lồng ngoặc trong [showModalBottomSheet].
class _TransactionDetailSheet extends StatelessWidget {
  final TransactionModel transaction;
  final PaletteColors palette;

  const _TransactionDetailSheet({
    required this.transaction,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHandle(p),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: (transaction.isIncome ? p.incomeColor : p.expenseColor).withValues(alpha: 0.2),
                child: Icon(
                  transaction.icon,
                  color: transaction.isIncome ? p.incomeColor : p.expenseColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: TextStyle(
                        color: p.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.date,
                      style: TextStyle(color: p.subtitleText, fontSize: 14),
                    ),
                    if (transaction.category.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          transaction.category,
                          style: TextStyle(color: p.subtitleText, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '${transaction.isIncome ? '+' : '-'}${formatCurrency(parseAmountFromString(transaction.amount), currency: '₫', decimalDigits: 0)}',
                style: TextStyle(
                  color: transaction.isIncome ? p.incomeColor : p.expenseColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHandle(PaletteColors p) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: p.borderColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
