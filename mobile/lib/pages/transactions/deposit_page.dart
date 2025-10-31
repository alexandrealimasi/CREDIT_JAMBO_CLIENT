import 'package:flutter/material.dart';
import 'package:mobile/pages/transactions/add_deposit_page.dart';
import 'package:mobile/providers/transaction_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/utils/data_helper.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../models/transaction_model.dart';
// import '../transactions/add_deposit_page.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Deposits",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              final transactionProvider = Provider.of<TransactionProvider>(
                context,
                listen: false,
              );
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
            icon: Icon(Icons.refresh, color: Colors.grey[600]),
          ),
        ],
      ),
      body: Consumer2<UserProvider, TransactionProvider>(
        builder: (context, userProvider, transactionProvider, child) {
          final depositHistory = transactionProvider.transactions
              .where((tx) => tx.type.toLowerCase() == "deposit")
              .toList();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header + Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Deposit History",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddDepositPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: AppColors.background),
                      label: const Text(
                        "New Deposit",
                        style: TextStyle(color: AppColors.background),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                transactionProvider.loading
                    ? const Center(
                        heightFactor: 10,
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: depositHistory.isEmpty
                            ? Center(
                                child: Text(
                                  "No deposits yet",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: depositHistory.length,
                                itemBuilder: (context, index) {
                                  final tx = depositHistory[index];
                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.1),
                                        child: const Icon(
                                          Icons.arrow_downward,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      title: Text(
                                        "\$${tx.amount.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        formatDateTimeAmPm(tx.date),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
