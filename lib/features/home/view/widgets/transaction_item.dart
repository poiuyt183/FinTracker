import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.onTap,
  });

  factory TransactionItem.fromModel(TransactionModel model, {VoidCallback? onTap}) {
    return TransactionItem(
      icon: model.icon,
      title: model.title,
      date: model.date,
      amount: model.amount,
      isIncome: model.isIncome,
      onTap: onTap,
    );
  }

  String get _formattedAmount =>
      formatCurrency(parseAmountFromString(amount), currency: '₫', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isIncome ? p.incomeColor : p.expenseColor).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isIncome ? p.incomeColor : p.expenseColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: p.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    color: p.subtitleText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formattedAmount,
            style: TextStyle(
              color: isIncome ? p.incomeColor : p.expenseColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      );
    }
    return content;
  }
}
