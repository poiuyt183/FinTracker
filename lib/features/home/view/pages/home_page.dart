import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/auth/viewmodel/auth_provider.dart';
import 'package:frontend/features/get_started/views/pages/get_started_page.dart';
import 'package:frontend/features/home/models/wallet_model.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/models/chart_data_model.dart';
import 'package:frontend/features/home/utils/chart_data_from_transactions.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/view/pages/money_lover_home.dart';
import 'package:frontend/features/settings/views/pages/settings_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<WalletModel> _wallets = [
    const WalletModel(
      icon: Icons.credit_card,
      color: Colors.teal,
      title: "ACB Credit Platin...",
      amount: "-15,884,000 ₫",
    ),
    const WalletModel(
      icon: Icons.laptop,
      color: Colors.orange,
      title: "Mua MacBook Pro",
      amount: "11,270,000 ₫",
    ),
    const WalletModel(
      icon: Icons.money,
      color: Colors.green,
      title: "Tiền mặt",
      amount: "10,000,000 ₫",
    ),
  ];

  final List<TransactionModel> _transactions = [
    TransactionModel(
      icon: Icons.account_balance_wallet,
      title: "Tiền chuyển đến",
      date: "1 tháng 2 2026",
      amount: "5,000,000",
      isIncome: true,
      category: "Chuyển khoản",
    ),
    TransactionModel(
      icon: Icons.restaurant,
      title: "Ăn uống",
      date: "1 tháng 2 2026",
      amount: "350,000",
      isIncome: false,
      category: "Ăn uống",
    ),
    TransactionModel(
      icon: Icons.directions_car,
      title: "Xăng xe",
      date: "3 tháng 2 2026",
      amount: "500,000",
      isIncome: false,
      category: "Di chuyển",
    ),
    TransactionModel(
      icon: Icons.payments,
      title: "Thu nợ",
      date: "5 tháng 2 2026",
      amount: "2,000,000",
      isIncome: true,
      category: "Thu nợ",
    ),
    TransactionModel(
      icon: Icons.shopping_bag,
      title: "Mua sắm",
      date: "5 tháng 2 2026",
      amount: "1,200,000",
      isIncome: false,
      category: "Mua sắm",
    ),
    TransactionModel(
      icon: Icons.medical_services,
      title: "Sức khỏe",
      date: "8 tháng 2 2026",
      amount: "30,000",
      isIncome: false,
      category: "Sức khỏe",
    ),
    TransactionModel(
      icon: Icons.account_balance_wallet,
      title: "Lương",
      date: "10 tháng 2 2026",
      amount: "15,000,000",
      isIncome: true,
      category: "Lương",
    ),
    TransactionModel(
      icon: Icons.restaurant,
      title: "Ăn uống",
      date: "10 tháng 2 2026",
      amount: "280,000",
      isIncome: false,
      category: "Ăn uống",
    ),
    TransactionModel(
      icon: Icons.movie,
      title: "Giải trí",
      date: "12 tháng 2 2026",
      amount: "200,000",
      isIncome: false,
      category: "Giải trí",
    ),
    TransactionModel(
      icon: Icons.local_gas_station,
      title: "Xăng",
      date: "15 tháng 2 2026",
      amount: "450,000",
      isIncome: false,
      category: "Di chuyển",
    ),
    TransactionModel(
      icon: Icons.card_giftcard,
      title: "Quà sinh nhật",
      date: "18 tháng 2 2026",
      amount: "800,000",
      isIncome: false,
      category: "Quà tặng",
    ),
    TransactionModel(
      icon: Icons.payments,
      title: "Thu nợ",
      date: "20 tháng 2 2026",
      amount: "3,000,000",
      isIncome: true,
      category: "Thu nợ",
    ),
    TransactionModel(
      icon: Icons.restaurant,
      title: "Ăn uống",
      date: "22 tháng 2 2026",
      amount: "420,000",
      isIncome: false,
      category: "Ăn uống",
    ),
    TransactionModel(
      icon: Icons.shopping_cart,
      title: "Siêu thị",
      date: "25 tháng 2 2026",
      amount: "650,000",
      isIncome: false,
      category: "Siêu thị",
    ),
    TransactionModel(
      icon: Icons.phone_android,
      title: "Tiền điện thoại",
      date: "28 tháng 2 2026",
      amount: "100,000",
      isIncome: false,
      category: "Công nghệ",
    ),
  ];

  ChartDataModel get _chartData => chartDataFromTransactions(
        _transactions,
        month: 2,
        year: 2026,
        daysInMonth: 28,
      );

  String get _totalBalance {
    double sum = 0;
    for (final w in _wallets) {
      final value = parseAmountFromString(w.amount);
      sum += w.amount.trim().startsWith('-') ? -value : value;
    }
    return formatCurrency(sum, currency: '₫', decimalDigits: 0);
  }

  List<Widget> _buildPages(BuildContext context) {
    return [
      FinTrackerHome(
        wallets: _wallets,
        transactions: _transactions,
        chartData: _chartData,
        totalBalance: _totalBalance,
        onWalletsUpdated: (list) => setState(() => _wallets = list),
        onViewAllTransactions: () => setState(() => _selectedIndex = 1),
        onSettingsTap: () => _showSettingsMenu(context),
      ),
      Center(child: Text('transactions'.tr())),
      Center(child: Text('add'.tr())),
      Center(child: Text('budget'.tr())),
      Center(child: Text('account'.tr())),
    ];
  }

  void _showSettingsMenu(BuildContext context) {
    final p = paletteOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: p.dialogBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: p.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: p.primaryText),
              title: Text('profile'.tr(), style: TextStyle(color: p.primaryText)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: p.primaryText),
              title: Text('settings'.tr(), style: TextStyle(color: p.primaryText)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            Divider(color: p.borderColor),
            ListTile(
              leading: Icon(Icons.logout, color: p.expenseColor),
              title: Text('sign_out'.tr(), style: TextStyle(color: p.expenseColor)),
              onTap: () async {
                Navigator.pop(context);
                _showSignOutDialog(context);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final p = paletteOf(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'sign_out'.tr(),
          style: TextStyle(color: p.primaryText, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'sign_out_confirm'.tr(),
          style: TextStyle(color: p.subtitleText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(), style: TextStyle(color: p.subtitleText)),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return TextButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GetStartedPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'sign_out'.tr(),
                        style: TextStyle(
                          color: p.expenseColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final pages = _buildPages(context);

    return Scaffold(
      backgroundColor: p.backgroundColor,
      body: Column(
        children: [
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: p.appBarBg,
        selectedItemColor: p.primaryAction,
        unselectedItemColor: p.subtitleText,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'overview'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.account_balance_wallet), label: 'transactions'.tr()),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: p.primaryAction,
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: const Icon(Icons.pie_chart), label: 'budget'.tr()),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: 'account'.tr()),
        ],
      ),
    );
  }
}
