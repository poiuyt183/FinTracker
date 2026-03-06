import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/utils/category_spending_from_transactions.dart';
import 'package:frontend/features/home/utils/monthly_report_helper.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/view/widgets/transaction_item.dart';
import 'package:frontend/features/home/view/widgets/detail_screen_app_bar.dart';

/// Màn xem chi tiết chi tiêu theo tháng (tab ngang), mỗi tháng hiện các category và giao dịch.
class TopSpendingDetailScreen extends StatefulWidget {
  final List<TransactionModel> transactions;

  const TopSpendingDetailScreen({
    super.key,
    required this.transactions,
  });

  @override
  State<TopSpendingDetailScreen> createState() => _TopSpendingDetailScreenState();
}

class _TopSpendingDetailScreenState extends State<TopSpendingDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<DateTime> _months;
  late List<CategorySpendingResult> _monthlyResults;
  /// Key: "monthIndex_categoryName" — danh mục đang mở (dropdown) để xem transaction.
  final Set<String> _expandedCategoryKeys = {};

  bool _isExpanded(int monthIndex, String categoryName) {
    return _expandedCategoryKeys.contains('${monthIndex}_$categoryName');
  }

  void _toggleExpanded(int monthIndex, String categoryName) {
    setState(() {
      final key = '${monthIndex}_$categoryName';
      if (_expandedCategoryKeys.contains(key)) {
        _expandedCategoryKeys.remove(key);
      } else {
        _expandedCategoryKeys.add(key);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _months = last12MonthsFromNow();
    _monthlyResults = _months
        .map((d) => buildCategorySpendingFromTransactions(
              widget.transactions,
              periodMonth: d.month,
              periodYear: d.year,
            ))
        .toList();
    _tabController = TabController(length: _months.length, vsync: this);
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
        title: 'spending_by_month'.tr(),
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
          tabs: _months
              .map((d) => Tab(
                    text: 'T${d.month}/${d.year.toString().substring(2)}',
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(
          _monthlyResults.length,
          (i) => _buildMonthContent(context, i, _monthlyResults[i]),
        ),
      ),
    );
  }

  Widget _buildMonthContent(BuildContext context, int monthIndex, CategorySpendingResult result) {
    final p = paletteOf(context);
    final shadow = shadowColorOf(context);
    if (result.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart_outline, size: 56, color: p.iconMuted),
              const SizedBox(height: 16),
              Text(
                'no_expense_this_month'.tr(),
                style: TextStyle(color: p.subtitleText, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: result.items.length,
      itemBuilder: (context, index) {
        final item = result.items[index];
        final raw = result.categoryTransactions[item.categoryName] ?? [];
        final transactions = transactionsSortedByDateDescending(raw);
        final isExpanded = _isExpanded(monthIndex, item.categoryName);
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: p.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.borderColor.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _toggleExpanded(monthIndex, item.categoryName),
                  child: Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(16),
                        bottom: Radius.circular(isExpanded ? 0 : 16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: item.color.withValues(alpha: 0.2),
                          child: Icon(item.icon, color: item.color, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.categoryName,
                                style: TextStyle(
                                  color: p.primaryText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (item.percentage > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    '${item.percentage.toStringAsFixed(1)}% · ${item.amount}',
                                    style: TextStyle(color: p.subtitleText, fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          item.amount,
                          style: TextStyle(
                            color: p.expenseColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: p.subtitleText,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  decoration: BoxDecoration(
                    color: p.sectionContentBg,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(height: 1, color: p.borderColor.withValues(alpha: 0.8)),
                      ...transactions.map((t) => TransactionItem.fromModel(t)),
                    ],
                  ),
                ),
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        );
      },
    );
  }
}
