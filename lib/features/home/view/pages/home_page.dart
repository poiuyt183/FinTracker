
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_pallete_dark.dart';
import 'package:frontend/core/theme/app_pallete_light.dart';
import 'package:frontend/features/auth/viewmodel/auth_provider.dart';
import 'package:frontend/features/get_started/views/pages/get_started_page.dart';
import 'package:frontend/features/home/transaction_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
const HomePage({super.key});

@override
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
int _selectedIndex = 0;

final double totalBalance = 15750000;

final List<Map<String, dynamic>> wallets = [
{
'name': 'Ví tiền mặt',
'icon': Icons.account_balance_wallet,
'balance': 5000000,
'color': Colors.blue,
},
{
'name': 'Ngân hàng',
'icon': Icons.account_balance,
'balance': 10000000,
'color': Colors.green,
},
{
'name': 'Thẻ tín dụng',
'icon': Icons.credit_card,
'balance': 750000,
'color': Colors.orange,
},
];

void _onItemTapped(int index) {
if (index == 2) {
_showAddTransaction();
return;
}

setState(() {
_selectedIndex = index;
});
}

void _showAddTransaction() {
showModalBottomSheet(
context: context,
isScrollControlled: true,
backgroundColor: Colors.white,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
),
builder: (context) {
TextEditingController title = TextEditingController();
TextEditingController amount = TextEditingController();

return Padding(
padding: EdgeInsets.only(
left: 20,
right: 20,
top: 20,
bottom: MediaQuery.of(context).viewInsets.bottom + 20,
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Text(
"Thêm giao dịch",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

TextField(
controller: title,
decoration: const InputDecoration(
labelText: "Tên giao dịch",
),
),

const SizedBox(height: 10),

TextField(
controller: amount,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Số tiền",
),
),

const SizedBox(height: 20),

ElevatedButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text("Lưu giao dịch"),
)
],
),
);
},
);
}

void _showSettingsMenu(BuildContext context, bool isDark) {
showModalBottomSheet(
context: context,
backgroundColor: isDark ? Colors.white : PalleteDark.backgroundColor,
shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
),
builder: (context) => Padding(
padding: const EdgeInsets.all(20),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
ListTile(
leading: Icon(
Icons.person_outline,
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
title: Text(
'Profile',
style: TextStyle(
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
),
),
ListTile(
leading: Icon(
Icons.settings,
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
title: Text(
'Settings',
style: TextStyle(
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
),
),
const Divider(),
ListTile(
leading: const Icon(Icons.logout, color: Colors.red),
title: const Text(
'Sign Out',
style: TextStyle(color: Colors.red),
),
onTap: () {
Navigator.pop(context);
_showSignOutDialog(context, isDark);
},
),
],
),
),
);
}

void _showSignOutDialog(BuildContext context, bool isDark) {
showDialog(
context: context,
builder: (context) => AlertDialog(
backgroundColor: isDark ? Colors.white : PalleteDark.backgroundColor,
title: Text(
'Sign Out',
style: TextStyle(
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
),
content: Text(
'Are you sure you want to sign out?',
style: TextStyle(
color: isDark
? PalleteLight.subtitleText
    : PalleteDark.subtitleText,
),
),
actions: [
TextButton(
child: const Text("Cancel"),
onPressed: () => Navigator.pop(context),
),
Consumer<AuthProvider>(
builder: (context, authProvider, child) {
return TextButton(
onPressed: () async {
await authProvider.signOut();

if (context.mounted) {
Navigator.pushAndRemoveUntil(
context,
MaterialPageRoute(
builder: (context) => const GetStartedPage(),
),
(route) => false,
);
}
},
child: const Text(
"Sign Out",
style: TextStyle(color: Colors.red),
),
);
},
)
],
),
);
}

Widget _buildHomeContent(bool isDark) {
return SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 32),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 24),

Container(
width: double.infinity,
padding: const EdgeInsets.all(28),
decoration: BoxDecoration(
color: isDark ? Colors.black : Colors.white,
borderRadius: BorderRadius.circular(20),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Tổng số dư',
style: TextStyle(
color: isDark ? Colors.white70 : Colors.black54,
),
),
const SizedBox(height: 10),
Text(
'${totalBalance.toStringAsFixed(0)} đ',
style: TextStyle(
color: isDark ? Colors.white : Colors.black,
fontSize: 32,
fontWeight: FontWeight.bold,
),
),
],
),
),

const SizedBox(height: 40),

const Text(
"Ví của tôi",
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
),

const SizedBox(height: 20),

ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: wallets.length,
itemBuilder: (context, index) {
final wallet = wallets[index];

return Container(
margin: const EdgeInsets.only(bottom: 16),
decoration: BoxDecoration(
color: isDark ? Colors.grey[100] : PalleteDark.cardColor,
borderRadius: BorderRadius.circular(16),
),
child: ListTile(
leading: Icon(wallet['icon'], color: wallet['color']),
title: Text(wallet['name']),
subtitle: Text("${wallet['balance']} đ"),
trailing: const Icon(Icons.arrow_forward_ios, size: 16),
),
);
},
),

const SizedBox(height: 40),
],
),
),
);
}

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final isDark = theme.brightness != Brightness.dark;

final List<Widget> pages = [
_buildHomeContent(isDark),
TransactionPage(),
Container(),
const Center(child: Text("Báo cáo")),
const Center(child: Text("Tài khoản")),
];

return Scaffold(
backgroundColor: isDark ? Colors.white : PalleteDark.backgroundColor,
appBar: AppBar(
backgroundColor: isDark ? Colors.white : PalleteDark.backgroundColor,
elevation: 0,
title: Text(
'Tài chính của tôi',
style: TextStyle(
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
),
actions: [
IconButton(
icon: Icon(
Icons.notifications_outlined,
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
onPressed: () {},
),
IconButton(
icon: Icon(
Icons.settings_outlined,
color: isDark ? Colors.black87 : PalleteDark.whiteColor,
),
onPressed: () => _showSettingsMenu(context, isDark),
),
],
),
body: pages[_selectedIndex],

bottomNavigationBar: BottomNavigationBar(
currentIndex: _selectedIndex,
onTap: _onItemTapped,
type: BottomNavigationBarType.fixed,
selectedItemColor: isDark ? Colors.black : Colors.white,
unselectedItemColor: Colors.grey,
items: const [
BottomNavigationBarItem(
icon: Icon(Icons.home_outlined),
activeIcon: Icon(Icons.home),
label: 'Trang chủ',
),
BottomNavigationBarItem(
icon: Icon(Icons.account_balance_wallet_outlined),
activeIcon: Icon(Icons.account_balance_wallet),
label: 'Giao dịch',
),
BottomNavigationBarItem(
icon: Icon(Icons.add_circle_outline),
activeIcon: Icon(Icons.add_circle),
label: 'Thêm',
),
BottomNavigationBarItem(
icon: Icon(Icons.bar_chart_outlined),
activeIcon: Icon(Icons.bar_chart),
label: 'Báo cáo',
),
BottomNavigationBarItem(
icon: Icon(Icons.person_outline),
activeIcon: Icon(Icons.person),
label: 'Tài khoản',
),
],
),
);
}
}

