import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_pallete_dark.dart';
import 'package:frontend/core/theme/app_pallete_light.dart';

/// Trả về palette tương ứng theme hiện tại (sáng/tối) để dùng thống nhất màu.
PaletteColors paletteOf(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? PaletteColors.dark
      : PaletteColors.light;
}

/// Màu shadow theo theme (dùng cho BoxShadow).
Color shadowColorOf(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.black.withValues(alpha: 0.2)
      : Colors.black.withValues(alpha: 0.08);
}

/// Gói màu dùng chung cho home/section; dark và light có cùng tên thuộc tính.
class PaletteColors {
  const PaletteColors._({
    required this.backgroundColor,
    required this.cardSurface,
    required this.sectionHeaderBg,
    required this.sectionContentBg,
    required this.primaryAction,
    required this.incomeColor,
    required this.expenseColor,
    required this.primaryText,
    required this.subtitleText,
    required this.iconMuted,
    required this.appBarBg,
    required this.dialogBg,
    required this.borderColor,
    required this.overlayOnInk,
    required this.tabSelectedBg,
    required this.leadingIconBg,
    required this.chartGridLine,
    required this.chartAverageLine,
  });

  final Color backgroundColor;
  final Color cardSurface;
  final Color sectionHeaderBg;
  final Color sectionContentBg;
  final Color primaryAction;
  final Color incomeColor;
  final Color expenseColor;
  final Color primaryText;
  final Color subtitleText;
  final Color iconMuted;
  final Color appBarBg;
  final Color dialogBg;
  final Color borderColor;
  final Color overlayOnInk;
  final Color tabSelectedBg;
  final Color leadingIconBg;
  final Color chartGridLine;
  final Color chartAverageLine;

  static const PaletteColors dark = PaletteColors._(
    backgroundColor: PalleteDark.backgroundColor,
    cardSurface: PalleteDark.cardSurface,
    sectionHeaderBg: PalleteDark.sectionHeaderBg,
    sectionContentBg: PalleteDark.sectionContentBg,
    primaryAction: PalleteDark.primaryAction,
    incomeColor: PalleteDark.incomeColor,
    expenseColor: PalleteDark.expenseColor,
    primaryText: PalleteDark.primaryText,
    subtitleText: PalleteDark.subtitleText,
    iconMuted: PalleteDark.iconMuted,
    appBarBg: PalleteDark.appBarBg,
    dialogBg: PalleteDark.dialogBg,
    borderColor: PalleteDark.borderColor,
    overlayOnInk: Colors.white24,
    tabSelectedBg: PalleteDark.tabSelectedBg,
    leadingIconBg: PalleteDark.leadingIconBg,
    chartGridLine: PalleteDark.chartGridLine,
    chartAverageLine: PalleteDark.chartAverageLine,
  );

  static const PaletteColors light = PaletteColors._(
    backgroundColor: PalleteLight.backgroundColor,
    cardSurface: PalleteLight.cardSurface,
    sectionHeaderBg: PalleteLight.sectionHeaderBg,
    sectionContentBg: PalleteLight.sectionContentBg,
    primaryAction: PalleteLight.primaryAction,
    incomeColor: PalleteLight.incomeColor,
    expenseColor: PalleteLight.expenseColor,
    primaryText: PalleteLight.primaryText,
    subtitleText: PalleteLight.subtitleText,
    iconMuted: PalleteLight.iconMuted,
    appBarBg: PalleteLight.appBarBg,
    dialogBg: PalleteLight.dialogBg,
    borderColor: PalleteLight.borderColor,
    overlayOnInk: PalleteLight.overlayLight,
    tabSelectedBg: PalleteLight.tabSelectedBg,
    leadingIconBg: PalleteLight.leadingIconBg,
    chartGridLine: PalleteLight.chartGridLine,
    chartAverageLine: PalleteLight.chartAverageLine,
  );
}
