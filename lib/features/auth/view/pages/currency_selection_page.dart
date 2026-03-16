import 'package:flutter/material.dart';
import 'package:frontend/core/services/settings_service.dart';
import 'package:frontend/core/theme/app_pallete_dark.dart';
import 'package:frontend/core/theme/app_pallete_light.dart';
import 'package:frontend/features/home/view/pages/home_page.dart';

class CurrencySelectionPage extends StatefulWidget {
  const CurrencySelectionPage({super.key});

  @override
  State<CurrencySelectionPage> createState() => _CurrencySelectionPageState();
}

class _CurrencySelectionPageState extends State<CurrencySelectionPage> {
  final List<String> _options = ['USD', 'VND', 'EUR', 'JPY'];
  String? _selected;

  @override
  void initState() {
    super.initState();
    // Optionally pre-load stored value
    SettingsService.getCurrency().then((v) {
      if (v != null && mounted) {
        setState(() {
          _selected = v;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness != Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.white : PalleteDark.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.attach_money,
                  color: isDark ? Colors.black87 : PalleteDark.whiteColor,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 40),
              Text(
                'Choose Currency',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.black87 : PalleteDark.whiteColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select your preferred currency to display amounts',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? PalleteLight.subtitleText
                      : PalleteDark.subtitleText,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final code = _options[idx];
                    final isSelected = code == _selected;
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: isDark
                          ? Colors.grey.shade100
                          : Colors.transparent,
                      title: Text(
                        code,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(_currencyName(code)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => setState(() => _selected = code),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () async {
                          await SettingsService.setCurrency(_selected!);
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _currencyName(String code) {
    switch (code) {
      case 'USD':
        return 'United States Dollar';
      case 'VND':
        return 'Vietnamese Dong';
      case 'EUR':
        return 'Euro';
      case 'JPY':
        return 'Japanese Yen';
      default:
        return '';
    }
  }
}
