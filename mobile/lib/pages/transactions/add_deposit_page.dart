import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/providers/transaction_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';

class AddDepositPage extends StatefulWidget {
  const AddDepositPage({super.key});

  @override
  State<AddDepositPage> createState() => _AddDepositPageState();
}

class _AddDepositPageState extends State<AddDepositPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void handleDeposit({
    required UserProvider userProvider,
    required TransactionProvider transactionProvider,
  }) async {
    final amount = _amountController.text.trim();
    final desc = _descController.text.trim();

    if (amount.isEmpty) {
      CustomDialog.infoDialog(
        context,
        title: "Missing Amount",
        desc: "Please enter a deposit amount.",
      );
      return;
    }

    final double? parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      CustomDialog.errorDialog(
        context,
        title: "Invalid Amount",
        desc: "Please enter a valid positive number.",
      );
      return;
    }

    EasyLoading.show(status: "Processing Deposit...");

    await transactionProvider.addDeposit(
      amount: parsedAmount,
      note: desc,
      token: userProvider.token!,
      onSuccess: (data) {
        EasyLoading.dismiss();
        CustomDialog.successDialog(
          context,
          title: "Deposit Successful",
          desc:
              "Your deposit of \$${parsedAmount.toStringAsFixed(2)} has been added.",
        );

        _amountController.clear();
        _descController.clear();
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
      onError: (message) {
        EasyLoading.dismiss();
        CustomDialog.errorDialog(
          context,
          title: "Deposit Failed",
          desc: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, _) => Scaffold(
        appBar: AppBar(
          title: const Text("Add Deposit"),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Deposit Details",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),

                /// Amount Input
                TextField(
                  controller: _amountController,
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
                  controller: _descController,
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

                /// Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => handleDeposit(
                      userProvider: userProvider,
                      transactionProvider: transactionProvider,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Deposit",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
