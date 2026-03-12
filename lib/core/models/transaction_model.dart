class TransactionModel {
  final String title;
  final String note;
  final double amount;
  final bool isIncome;
  final DateTime date;

  TransactionModel({
    required this.title,
    required this.note,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}