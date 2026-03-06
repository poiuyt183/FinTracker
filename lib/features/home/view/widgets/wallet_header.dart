import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/wallet_model.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';

class WalletItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String amount;

  const WalletItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
  });

  factory WalletItem.fromModel(WalletModel model) {
    return WalletItem(
      icon: model.icon,
      color: model.color,
      title: model.title,
      amount: model.amount,
    );
  }

  String get _formattedAmount {
    final value = parseAmountFromString(amount);
    final signed = amount.trim().startsWith('-') ? -value : value;
    return formatCurrency(signed, currency: '₫', decimalDigits: 0);
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: p.primaryText,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        _formattedAmount,
        style: TextStyle(
          color: p.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
