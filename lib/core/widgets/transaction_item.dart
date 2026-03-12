import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
        transaction.isIncome ? Colors.blue.shade100 : Colors.red.shade100,
        child: Icon(
          transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.isIncome ? Colors.blue : Colors.red,
        ),
      ),
      title: Text(transaction.title),
      subtitle: Text(transaction.note),
      trailing: Text(
        "${transaction.isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} đ",
        style: TextStyle(
          color: transaction.isIncome ? Colors.blue : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}