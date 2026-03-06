import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/models/category_spending_model.dart';
import 'package:frontend/features/home/utils/category_spending_from_transactions.dart';
import 'package:frontend/features/home/view/pages/top_spending_detail_screen.dart';
import 'package:frontend/features/home/view/widgets/section_header.dart';

class TopSpending extends StatefulWidget {
  final List<TransactionModel> transactions;
  /// Lọc theo tháng (null = tất cả). Tab "Tháng" dùng tháng hiện tại.
  final bool filterByCurrentMonth;

  const TopSpending({
    super.key,
    required this.transactions,
    this.filterByCurrentMonth = true,
  });

  @override
  State<TopSpending> createState() => _TopSpendingState();
}

class _TopSpendingState extends State<TopSpending> {
  bool _isWeekSelected = true;
  int? _hoveredTabIndex;

  CategorySpendingResult get _result {
    final now = DateTime.now();
    if (widget.filterByCurrentMonth && !_isWeekSelected) {
      return buildCategorySpendingFromTransactions(
        widget.transactions,
        periodMonth: now.month,
        periodYear: now.year,
      );
    }
    return buildCategorySpendingFromTransactions(widget.transactions);
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final shadow = shadowColorOf(context);
    final result = _result;
    final items = result.items.take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: p.cardSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: p.sectionContentBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: SectionHeader(
              title: 'top_spending'.tr(),
              actionText: 'view_detail'.tr(),
              onActionTap: items.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopSpendingDetailScreen(
                            transactions: widget.transactions,
                          ),
                        ),
                      );
                    },
            ),
          ),
          Divider(height: 1, color: p.borderColor.withValues(alpha: 0.8)),
          Container(
            decoration: BoxDecoration(
              color: p.sectionContentBg,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTab(context, 0, "Tuần", _isWeekSelected, () => setState(() => _isWeekSelected = true)),
                    ),
                    Expanded(
                      child: _buildTab(context, 1, "Tháng", !_isWeekSelected, () => setState(() => _isWeekSelected = false)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(Icons.analytics_outlined, size: 52, color: p.iconMuted),
                        const SizedBox(height: 16),
                        Text(
                          "Nhóm chi tiêu nhiều nhất sẽ hiển thị ở đây",
                          style: TextStyle(color: p.subtitleText, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  ...items.map((item) => _buildSpendingRow(context, item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String label, bool isSelected, VoidCallback onTap) {
    final p = paletteOf(context);
    final isHovered = _hoveredTabIndex == index;
    final bgColor = isSelected
        ? p.tabSelectedBg
        : (isHovered ? p.tabSelectedBg : Colors.transparent);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredTabIndex = index),
      onExit: (_) => setState(() => _hoveredTabIndex = null),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? p.primaryText : (isHovered ? p.subtitleText : p.iconMuted),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingRow(BuildContext context, CategorySpendingModel item) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.color.withValues(alpha: 0.2),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.categoryName,
                  style: TextStyle(
                    color: p.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.percentage > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '${item.percentage.toStringAsFixed(1)}%',
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
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
