import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/theme_palette.dart';
import 'package:frontend/features/home/models/wallet_model.dart';
import 'package:frontend/features/home/view/widgets/wallet_header.dart';
import 'package:frontend/features/home/view/widgets/detail_screen_app_bar.dart';
import 'package:frontend/features/home/utils/currency_formatter.dart';

class WalletManagementScreen extends StatefulWidget {
  final List<WalletModel> initialWallets;

  const WalletManagementScreen({
    super.key,
    required this.initialWallets,
  });

  @override
  State<WalletManagementScreen> createState() => _WalletManagementScreenState();
}

class _WalletManagementScreenState extends State<WalletManagementScreen> {
  late List<WalletModel> _wallets;
  bool _isFabHovered = false;

  @override
  void initState() {
    super.initState();
    _wallets = List.from(widget.initialWallets);
  }

  /// Quay về màn Home và truyền danh sách ví đã cập nhật.
  void _goBackToHome() {
    Navigator.pop(context, _wallets);
  }

  Future<void> _showAddWalletDialog() async {
    final result = await showDialog<WalletModel>(
      context: context,
      builder: (ctx) => _WalletFormDialog(dialogContext: ctx),
    );
    if (result != null && mounted) {
      setState(() => _wallets.add(result));
    }
  }

  Future<void> _showEditWalletDialog(int index) async {
    if (index < 0 || index >= _wallets.length) return;
    final result = await showDialog<WalletModel>(
      context: context,
      builder: (ctx) => _WalletFormDialog(dialogContext: ctx, initialWallet: _wallets[index]),
    );
    if (result != null && mounted) {
      setState(() => _wallets[index] = result);
    }
  }

  Future<void> _confirmDeleteWallet(int index) async {
    if (index < 0 || index >= _wallets.length) return;
    final wallet = _wallets[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final p = paletteOf(ctx);
        return AlertDialog(
          backgroundColor: p.dialogBg,
          title: Text('delete_wallet'.tr(), style: TextStyle(color: p.primaryText)),
          content: Text(
            'delete_wallet_confirm'.tr(namedArgs: {'title': wallet.title}),
            style: TextStyle(color: p.subtitleText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('cancel'.tr(), style: TextStyle(color: p.subtitleText)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('delete_wallet'.tr(), style: TextStyle(color: p.expenseColor)),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      setState(() => _wallets.removeAt(index));
    }
  }

  Widget _buildEmptyState(PaletteColors p) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: p.leadingIconBg.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 56,
                color: p.iconMuted,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'no_wallets'.tr(),
              style: TextStyle(
                color: p.primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'add_wallet_hint'.tr(),
              style: TextStyle(
                color: p.subtitleText,
                fontSize: 15,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _showAddWalletDialog,
              icon: const Icon(Icons.add, size: 20),
              label: Text('add_wallet'.tr()),
              style: FilledButton.styleFrom(
                backgroundColor: p.primaryAction,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(context);
    final shadow = shadowColorOf(context);
    return Scaffold(
      backgroundColor: p.backgroundColor,
      appBar: DetailScreenAppBar(
        title: 'wallet_management'.tr(),
        onBack: _goBackToHome,
      ),
      body: _wallets.isEmpty
          ? _buildEmptyState(p)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'wallet_list'.tr(),
                    style: TextStyle(
                      color: p.subtitleText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _wallets.length,
                      itemBuilder: (context, index) {
                        final wallet = _wallets[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: p.cardSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: p.borderColor.withValues(alpha: 0.6), width: 1),
                            boxShadow: [
                              BoxShadow(color: shadow, blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _showEditWalletDialog(index),
                              borderRadius: BorderRadius.circular(16),
                              overlayColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.hovered)) {
                                  return p.overlayOnInk;
                                }
                                return null;
                              }),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Row(
                                  children: [
                                    Expanded(child: WalletItem.fromModel(wallet)),
                                    IconButton(
                                      icon: Icon(Icons.edit_outlined, color: p.iconMuted, size: 22),
                                      onPressed: () => _showEditWalletDialog(index),
                                      tooltip: 'edit_wallet'.tr(),
                                      style: IconButton.styleFrom(overlayColor: p.overlayOnInk),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: p.iconMuted, size: 22),
                                      onPressed: () => _confirmDeleteWallet(index),
                                      tooltip: 'delete_wallet'.tr(),
                                      style: IconButton.styleFrom(
                                        overlayColor: p.expenseColor.withValues(alpha: 0.15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      floatingActionButton: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isFabHovered = true),
        onExit: (_) => setState(() => _isFabHovered = false),
        child: AnimatedScale(
          scale: _isFabHovered ? 1.08 : 1,
          duration: const Duration(milliseconds: 150),
          child: FloatingActionButton(
            onPressed: _showAddWalletDialog,
            backgroundColor: p.primaryAction,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _WalletFormDialog extends StatefulWidget {
  final BuildContext dialogContext;
  final WalletModel? initialWallet;

  const _WalletFormDialog({required this.dialogContext, this.initialWallet});

  @override
  State<_WalletFormDialog> createState() => _WalletFormDialogState();
}

class _WalletFormDialogState extends State<_WalletFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  static const List<Color> _colors = [
    Colors.teal,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.amber,
    Colors.cyan,
  ];

  static const List<IconData> _icons = [
    Icons.credit_card,
    Icons.money,
    Icons.account_balance,
    Icons.savings,
    Icons.wallet,
    Icons.payment,
    Icons.card_membership,
    Icons.account_balance_wallet,
  ];

  late Color _selectedColor;
  late IconData _selectedIcon;
  bool get _isEdit => widget.initialWallet != null;

  @override
  void initState() {
    super.initState();
    final w = widget.initialWallet;
    _titleController = TextEditingController(text: w?.title ?? '');
    _amountController = TextEditingController(text: w?.amount ?? formatCurrency(0, currency: '₫', decimalDigits: 0));
    _selectedColor = w?.color ?? _colors.first;
    _selectedIcon = w?.icon ?? _icons.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final amount = _amountController.text.trim();
      if (title.isEmpty) return;
      Navigator.pop(context, WalletModel(
        icon: _selectedIcon,
        color: _selectedColor,
        title: title,
        amount: amount.isEmpty ? formatCurrency(0, currency: '₫', decimalDigits: 0) : amount,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = paletteOf(widget.dialogContext);
    final shadow = shadowColorOf(widget.dialogContext);
    return Dialog(
      backgroundColor: p.dialogBg,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEdit ? 'edit_wallet'.tr() : 'add_wallet_new'.tr(),
                  style: TextStyle(
                    color: p.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: p.primaryText),
                  decoration: InputDecoration(
                    labelText: 'wallet_name'.tr(),
                    labelStyle: TextStyle(color: p.subtitleText),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: p.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: p.primaryAction),
                    ),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'wallet_name_required'.tr() : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  style: TextStyle(color: p.primaryText),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'balance'.tr() + ' (e.g. ${formatCurrency(10000000, currency: '₫', decimalDigits: 0)})',
                    labelStyle: TextStyle(color: p.subtitleText),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: p.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: p.primaryAction),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'choose_icon'.tr(),
                  style: TextStyle(color: p.subtitleText, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _icons.map((icon) {
                    final selected = icon == _selectedIcon;
                    return _HoverableChip(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected ? _selectedColor.withValues(alpha: 0.3) : p.leadingIconBg,
                          borderRadius: BorderRadius.circular(8),
                          border: selected ? Border.all(color: _selectedColor, width: 2) : null,
                        ),
                        child: Icon(icon, color: selected ? _selectedColor : p.iconMuted),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'choose_color'.tr(),
                  style: TextStyle(color: p.subtitleText, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _colors.map((color) {
                    final selected = color == _selectedColor;
                    return _HoverableChip(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selected ? Border.all(color: p.primaryText, width: 3) : null,
                          boxShadow: [
                            BoxShadow(
                              color: shadow,
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          overlayColor: p.overlayOnInk,
                          foregroundColor: p.subtitleText,
                        ),
                        child: Text('cancel'.tr()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: p.primaryAction,
                          overlayColor: p.overlayOnInk,
                        ),
                        child: Text(_isEdit ? 'update'.tr() : 'add_wallet'.tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverableChip extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _HoverableChip({required this.onTap, required this.child});

  @override
  State<_HoverableChip> createState() => _HoverableChipState();
}

class _HoverableChipState extends State<_HoverableChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.1 : 1,
          duration: const Duration(milliseconds: 120),
          child: widget.child,
        ),
      ),
    );
  }
}
