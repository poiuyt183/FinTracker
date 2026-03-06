import 'package:flutter/material.dart';

/// Light theme — Complementary (Teal ↔ Coral) + 60-30-10.
/// 60% dominant background, 30% cards/sections, 10% accent (teal + coral).
/// Tham khảo: Mint (teal), Notion (neutral + accent), Revolut (clean blue-grey).
class PalleteLight {
  // ─── 60% — Dominant (nền chính) ─────────────────────────────────────────
  static const Color backgroundColor = Color(0xFFF1F5F9); // slate-100

  // ─── 30% — Secondary (card, section) ──────────────────────────────────
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color sectionHeaderBg = Color(0xFFE2E8F0); // slate-200
  static const Color sectionContentBg = Color(0xFFF8FAFC); // slate-50
  static const Color appBarBg = Color(0xFFFFFFFF);
  static const Color dialogBg = Color(0xFFFFFFFF);

  // ─── 10% — Accent (Complementary: Teal + Coral) ─────────────────────────
  /// Teal — primary action, income, trust (như Mint/Revolut).
  static const Color primaryAction = Color(0xFF0D9488); // teal-600
  static const Color incomeColor = Color(0xFF0D9488);   // teal-600
  /// Coral/Orange — expense, CTA (complementary của teal).
  static const Color expenseColor = Color(0xFFEA580C);  // orange-600

  // ─── Neutrals (text, border) ───────────────────────────────────────────
  static const Color primaryText = Color(0xFF0F172A);   // slate-900
  static const Color subtitleText = Color(0xFF64748B);   // slate-500
  static const Color iconMuted = Color(0xFF64748B);     // slate-500
  static const Color borderColor = Color(0xFFE2E8F0);  // slate-200

  // ─── UI states ─────────────────────────────────────────────────────────
  static const Color greenColor = Color(0xFF0D9488);
  static const Color inactiveBottomBarItemColor = Color(0xFF94A3B8); // slate-400
  static const Color tabSelectedBg = Color(0xFFE2E8F0);
  static const Color leadingIconBg = Color(0xFFE2E8F0);
  static const Color overlayLight = Color(0x1F0F172A);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Color(0xFF64748B);
  static const Color errorColor = Color(0xFFDC2626);   // red-600
  static const Color transparentColor = Colors.transparent;
  static const Color inactiveSeekColor = Colors.black38;

  // ─── Chart ─────────────────────────────────────────────────────────────
  static const Color chartGridLine = Color(0x140F172A);
  static const Color chartAverageLine = Color(0x400F172A);

  // ─── Gradients (Complementary: Teal → Coral) ────────────────────────────
  static const Color gradient1 = Color(0xFF0D9488); // teal
  static const Color gradient2 = Color(0xFFF97316); // orange-500
  static const Color gradient3 = Color(0xFFEA580C); // orange-600
}
