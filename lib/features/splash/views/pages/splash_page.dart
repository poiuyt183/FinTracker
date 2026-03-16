import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_pallete_dark.dart';
import 'package:frontend/core/theme/app_pallete_light.dart';
import 'package:frontend/core/theme/theme_provider.dart';
import 'package:frontend/features/auth/viewmodel/auth_provider.dart';
import 'package:frontend/features/get_started/views/pages/get_started_page.dart';
import 'package:frontend/features/home/view/pages/home_page.dart';
import 'package:frontend/features/auth/view/pages/currency_selection_page.dart';
import 'package:frontend/core/services/settings_service.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? PalleteDark.backgroundColor
          : PalleteLight.backgroundColor,
      body: Center(
        child: Text(
          'FinTracker',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isAuthenticated = authProvider.isAuthenticated;

    if (isAuthenticated) {
      final currency = await SettingsService.getCurrency();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return currency == null
                ? const CurrencySelectionPage()
                : const HomePage();
          },
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const GetStartedPage(),
        ),
      );
    }
  }
}
