import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/providers/transaction_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';

class AddWithdrawPage extends StatefulWidget {
  const AddWithdrawPage({super.key});

  @override
  State<AddWithdrawPage> createState() => _AddWithdrawPageState();
}

class _AddWithdrawPageState extends State<AddWithdrawPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void confirmWithdraw({
    required UserProvider userProvider,
    required TransactionProvider transactionProvider,
  }) async {
    final amount = amountController.text.trim();
    final note = noteController.text.trim();

    if (amount.isEmpty) {
      CustomDialog.infoDialog(
        context,
        title: "Missing Amount",
        desc: "Please enter a withdrawal amount.",
      );
      return;
    }

    final value = double.tryParse(amount);
    if (value == null || value <= 0) {
      CustomDialog.errorDialog(
        context,
        title: "Invalid Amount",
        desc: "Please enter a valid number greater than zero.",
      );
      return;
    }
    EasyLoading.show(status: "Processing Withdrawal...");
    transactionProvider.addWithdraw(
      amount: value,
      note: note,
      token: userProvider.token!,
      onSuccess: (data) {
        EasyLoading.dismiss();
        CustomDialog.successDialog(
          context,
          title: "Withdrawal Successful",
          desc:
              "Your withdrawal of \$${value.toStringAsFixed(2)} has been processed.",
        );
        amountController.clear();
        noteController.clear();
        userProvider.updateBalance(double.parse(data['balance'].toString()));
        transactionProvider.setLoading(true);
        transactionProvider.fetchTransactions(
          token: userProvider.token!,
          onError: () {
            transactionProvider.setLoading(false);
          },
          onSuccess: () {
            transactionProvider.setLoading(false);
          },
        );
      },
      onError: (data) {
        EasyLoading.dismiss();
        CustomDialog.errorDialog(
          context,
          title: "Withdrawal Failed",
          desc: "${data['message']}",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Consumer2<UserProvider, TransactionProvider>(
        builder: (context, userProvider, transactionProvider, child) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Withdrawal Details",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  prefixIcon: const Icon(Icons.attach_money_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description (optional)",
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => confirmWithdraw(
                    transactionProvider: transactionProvider,
                    userProvider: userProvider,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Confirm Withdrawal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
