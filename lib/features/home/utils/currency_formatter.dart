/// Format số tiền kèm ký hiệu tiền tệ.
///
/// [value] — giá trị số (có thể là số nguyên hoặc thập phân).
/// [currency] — ký hiệu tiền tệ (ví dụ: "$", "₫", "USD").
/// [decimalDigits] — số chữ số thập phân (mặc định 2). Nếu [value] là số nguyên có thể dùng 0.
///
/// Ví dụ:
/// - formatCurrency(1000.25, '\$')  → "1,000.25 \$"
/// - formatCurrency(1000000, '₫')   → "1,000,000.00 ₫"
/// - formatCurrency(1000000, '₫', decimalDigits: 0) → "1,000,000 ₫"
String formatCurrency(
  num value, {
  String currency = '\$',
  int decimalDigits = 2,
}) {
  final digits = decimalDigits < 0 ? 0 : decimalDigits;
  final parts = value.abs().toStringAsFixed(digits).split('.');
  final intPart = parts[0];
  final decPart = parts.length > 1 ? parts[1] : '';

  final buffer = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(intPart[i]);
  }
  if (digits > 0) {
    final trimmed = decPart.replaceAll(RegExp(r'0+$'), '');
    if (trimmed.isNotEmpty) {
      buffer.write('.');
      buffer.write(trimmed);
    }
  }

  final sign = value < 0 ? '-' : '';
  return '$sign${buffer.toString()} $currency'.trim();
}
