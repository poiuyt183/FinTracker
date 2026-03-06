import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/view/widgets/detail_screen_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final themeProvider = context.watch<ThemeProvider>();
    final locale = context.locale;

    return Scaffold(
      backgroundColor: p.backgroundColor,
      appBar: DetailScreenAppBar(
        title: 'settings'.tr(),
        onBack: () => Navigator.maybePop(context),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _SectionTitle(label: 'language'.tr()),
          const SizedBox(height: 8),
          _OptionTile(
            title: 'english'.tr(),
            subtitle: 'English',
            selected: locale.languageCode == 'en',
            onTap: () async {
              await context.setLocale(const Locale('en'));
            },
            palette: p,
          ),
          const SizedBox(height: 8),
          _OptionTile(
            title: 'vietnamese'.tr(),
            subtitle: 'Tiếng Việt',
            selected: locale.languageCode == 'vi',
            onTap: () async {
              await context.setLocale(const Locale('vi'));
            },
            palette: p,
          ),
          const SizedBox(height: 28),
          _SectionTitle(label: 'theme'.tr()),
          const SizedBox(height: 8),
          _OptionTile(
            title: 'theme_light'.tr(),
            subtitle: null,
            selected: themeProvider.themeMode == ThemeMode.light,
            onTap: () => themeProvider.setTheme(ThemeMode.light),
            palette: p,
          ),
          const SizedBox(height: 8),
          _OptionTile(
            title: 'theme_dark'.tr(),
            subtitle: null,
            selected: themeProvider.themeMode == ThemeMode.dark,
            onTap: () => themeProvider.setTheme(ThemeMode.dark),
            palette: p,
          ),
          const SizedBox(height: 8),
          _OptionTile(
            title: 'theme_system'.tr(),
            subtitle: null,
            selected: themeProvider.themeMode == ThemeMode.system,
            onTap: () => themeProvider.setTheme(ThemeMode.system),
            palette: p,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;

  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(
          color: p.subtitleText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final PaletteColors palette;

  const _OptionTile({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? palette.primaryAction : palette.borderColor.withValues(alpha: 0.5),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: palette.primaryText,
                        fontSize: 16,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(color: palette.subtitleText, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: palette.primaryAction, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
