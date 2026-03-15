import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/view/widgets/section_header.dart';
import 'package:frontend/features/home/view/widgets/wallet_header.dart';
import 'package:frontend/features/home/view/widgets/transaction_item.dart';
import 'package:frontend/features/home/view/widgets/spending_chart.dart';
import 'package:frontend/features/home/view/widgets/top_spending.dart';
import 'package:frontend/features/home/models/transaction_model.dart';
import 'package:frontend/features/home/models/wallet_model.dart';
import 'package:frontend/features/home/models/chart_data_model.dart';
import 'package:frontend/features/home/utils/transaction_parser.dart';
import 'package:frontend/features/home/view/pages/wallet_management_screen.dart';
import 'package:frontend/features/home/view/pages/report_detail_screen.dart';

class FinTrackerHome extends StatelessWidget {
  final List<WalletModel> wallets;
  final List<TransactionModel> transactions;
  final ChartDataModel chartData;
  final String totalBalance;
  final void Function(List<WalletModel>)? onWalletsUpdated;
  final VoidCallback? onViewAllTransactions;
  final VoidCallback? onSettingsTap;

  const FinTrackerHome({
    super.key,
    required this.wallets,
    required this.transactions,
    required this.chartData,
    this.totalBalance = "5,386,000 ₫",
    this.onWalletsUpdated,
    this.onViewAllTransactions,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final shadow = shadowColorOf(context);

    return Scaffold(
      backgroundColor: p.backgroundColor,
      appBar: AppBar(
        backgroundColor: p.appBarBg,
        elevation: 0,
        title: Row(
          children: [
            Text(
              totalBalance,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                color: p.primaryAction,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.visibility_outlined, size: 18, color: p.iconMuted),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: p.iconMuted),
            onPressed: () {},
            style: IconButton.styleFrom(overlayColor: p.overlayOnInk),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: p.iconMuted),
            onPressed: () {},
            style: IconButton.styleFrom(overlayColor: p.overlayOnInk),
          ),
          if (onSettingsTap != null)
            IconButton(
              icon: Icon(Icons.settings_outlined, color: p.iconMuted),
              onPressed: onSettingsTap,
              style: IconButton.styleFrom(overlayColor: p.overlayOnInk),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [p.primaryAction, p.expenseColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  // 1. Ví của tôi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: p.cardSurface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: SectionHeader(
                      title: 'my_wallets'.tr(),
                      actionText: 'view_all'.tr(),
                      onActionTap: () async {
                        final result = await Navigator.push<List<WalletModel>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletManagementScreen(
                              initialWallets: List.from(wallets),
                            ),
                          ),
                        );
                        if (result != null && onWalletsUpdated != null) {
                          onWalletsUpdated!(result);
                        }
                      },
                    ),
                  ),
                  Divider(height: 1, color: p.borderColor.withValues(alpha: 0.8)),
                  Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < wallets.length; i++) ...[
                          WalletItem.fromModel(wallets[i]),
                          if (i < wallets.length - 1)
                            Divider(
                              height: 1,
                              indent: 72,
                              endIndent: 16,
                              color: p.borderColor.withValues(alpha: 0.6),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Báo cáo tháng này
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: p.cardSurface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: SectionHeader(
                      title: 'report_this_month'.tr(),
                      actionText: 'view_report'.tr(),
                      onActionTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailScreen(
                              transactions: transactions,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(height: 1, color: p.borderColor.withValues(alpha: 0.8)),
                  Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    child: SpendingChart(data: chartData, transactions: transactions),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Chi tiêu nhiều nhất
            TopSpending(transactions: transactions),

            const SizedBox(height: 16),

            // 4. Giao dịch gần đây
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: p.cardSurface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: SectionHeader(
                      title: 'recent_transactions'.tr(),
                      actionText: 'view_all'.tr(),
                      onActionTap: onViewAllTransactions,
                    ),
                  ),
                  Divider(height: 1, color: p.borderColor.withValues(alpha: 0.8)),
                  Container(
                    decoration: BoxDecoration(
                      color: p.sectionContentBg,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...recentTransactions(transactions, 3).map((item) => TransactionItem.fromModel(item)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
