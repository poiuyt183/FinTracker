
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int selectedFilter = 1;
  DateTime currentDate = DateTime.now();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isIncome = false;

  List<Map<String, dynamic>> transactions = [
    {
      "title": "Tiền chuyển đến",
      "note": "Điều chỉnh số dư",
      "amount": 7953000,
      "income": true,
      "icon": Icons.arrow_downward,
      "color": Colors.blue
    },
    {
      "title": "Ăn uống",
      "note": "Bữa tối bún riêu",
      "amount": 45000,
      "income": false,
      "icon": Icons.restaurant,
      "color": Colors.red
    },
  ];

  String formatMoney(num value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => "${m[1]},") +
        " đ";
  }

  void nextPeriod() {
    setState(() {
      if (selectedFilter == 0) {
        currentDate = currentDate.add(const Duration(days: 7));
      } else if (selectedFilter == 1) {
        currentDate = DateTime(currentDate.year, currentDate.month + 1);
      } else {
        currentDate = DateTime(currentDate.year + 1);
      }
    });
  }

  void previousPeriod() {
    setState(() {
      if (selectedFilter == 0) {
        currentDate = currentDate.subtract(const Duration(days: 7));
      } else if (selectedFilter == 1) {
        currentDate = DateTime(currentDate.year, currentDate.month - 1);
      } else {
        currentDate = DateTime(currentDate.year - 1);
      }
    });
  }

  String getPeriodText() {
    if (selectedFilter == 0) {
      return "Tuần ${weekNumber(currentDate)} ${currentDate.year}";
    } else if (selectedFilter == 1) {
      return "Tháng ${currentDate.month} ${currentDate.year}";
    } else {
      return "Năm ${currentDate.year}";
    }
  }

  int weekNumber(DateTime date) {
    final firstDay = DateTime(date.year, 1, 1);
    final difference = date.difference(firstDay).inDays;
    return ((difference + firstDay.weekday) / 7).ceil();
  }

  void showAddTransactionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff1c1c1c),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Tên giao dịch",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Số tiền",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: noteController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Ghi chú",
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Text(
                    "Loại:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<bool>(
                    dropdownColor: Colors.black,
                    value: isIncome,
                    items: const [
                      DropdownMenuItem(
                        value: false,
                        child: Text("Chi tiêu",
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text("Thu nhập",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        isIncome = value!;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {

                  setState(() {
                    transactions.add({
                      "title": titleController.text,
                      "note": noteController.text,
                      "amount": int.parse(amountController.text),
                      "income": isIncome,
                      "icon": isIncome
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      "color": isIncome ? Colors.blue : Colors.red,
                    });
                  });

                  titleController.clear();
                  amountController.clear();
                  noteController.clear();

                  Navigator.pop(context);
                },
                child: const Text("Lưu giao dịch"),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget filterButton(String text, int index) {
    final active = selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.green,
          ),
        ),
      ),
    );
  }

  Widget transactionItem(Map<String, dynamic> data) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: data["color"].withOpacity(0.2),
        child: Icon(data["icon"], color: data["color"]),
      ),
      title: Text(
        data["title"],
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        data["note"],
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        formatMoney(data["amount"]),
        style: TextStyle(
          color: data["income"] ? Colors.blue : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f0f),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                filterButton("Tuần", 0),
                filterButton("Tháng", 1),
                filterButton("Năm", 2),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: previousPeriod,
                ),
                Text(
                  getPeriodText(),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: nextPeriod,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xff1c1c1c),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: transactions
                          .map((e) => transactionItem(e))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: showAddTransactionForm,
      ),
    );
  }
}

