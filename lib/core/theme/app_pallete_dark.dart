import 'package:flutter/material.dart';

/// Dark theme — Complementary (Teal ↔ Coral) + 60-30-10.
/// 60% dominant dark, 30% cards/sections, 10% accent (teal + coral).
/// Tham khảo: Wallet (Apple), Linear dark, Revolut dark.
class PalleteDark {
  // ─── 60% — Dominant (nền chính) ─────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF0F172A); // slate-900

  // ─── 30% — Secondary (card, section) ──────────────────────────────────
  static const Color cardColor = Color(0xFF1E293B);       // slate-800
  static const Color cardSurface = Color(0xFF1E293B);     // slate-800
  static const Color sectionHeaderBg = Color(0xFF334155); // slate-700
  static const Color sectionContentBg = Color(0xFF1E293B); // slate-800
  static const Color appBarBg = Color(0xFF0F172A);        // slate-900
  static const Color dialogBg = Color(0xFF1E293B);       // slate-800

  // ─── 10% — Accent (Complementary: Teal + Coral) ─────────────────────────
  /// Teal — primary action, income.
  static const Color primaryAction = Color(0xFF2DD4BF);   // teal-400
  static const Color incomeColor = Color(0xFF2DD4BF);    // teal-400
  /// Coral/Orange — expense, CTA (sáng hơn cho dark mode).
  static const Color expenseColor = Color(0xFFFB923C);   // orange-400

  // ─── Neutrals (text, border) ───────────────────────────────────────────
  static const Color primaryText = Color(0xFFF8FAFC);     // slate-50
  static const Color subtitleText = Color(0xFF94A3B8);    // slate-400
  static const Color iconMuted = Color(0xFF94A3B8);       // slate-400
  static const Color borderColor = Color(0xFF334155);     // slate-700

  // ─── UI states ─────────────────────────────────────────────────────────
  static const Color greenColor = Color(0xFF2DD4BF);
  static const Color inactiveBottomBarItemColor = Color(0xFF64748B); // slate-500
  static const Color tabSelectedBg = Color(0xFF334155);
  static const Color leadingIconBg = Color(0xFF475569);  // slate-600
  static const Color overlayLight = Color(0x33FFFFFF);
  static const Color whiteColor = Color(0xFFF8FAFC);
  static const Color greyColor = Color(0xFF94A3B8);
  static const Color errorColor = Color(0xFFF87171);      // red-400
  static const Color transparentColor = Colors.transparent;
  static const Color inactiveSeekColor = Colors.white38;

  // ─── Chart ─────────────────────────────────────────────────────────────
  static const Color chartGridLine = Color(0x14F8FAFC);
  static const Color chartAverageLine = Color(0x40F8FAFC);

  // ─── Gradients (Complementary: Teal → Coral, tông tối) ───────────────────
  static const Color gradient1 = Color(0xFF0F766E); // teal-700
  static const Color gradient2 = Color(0xFFC2410C); // orange-700
  static const Color gradient3 = Color(0xFFEA580C); // orange-600
}
