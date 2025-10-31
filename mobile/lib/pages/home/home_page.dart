import 'package:flutter/material.dart';
import 'package:mobile/providers/transaction_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/utils/data_helper.dart';
import 'package:mobile/widgets/balance_card.dart';
import 'package:mobile/widgets/no_transaction_widget.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Welcome, ${userProvider.user?.name.split(' ').first ?? ''} 👋",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              BalanceCard(balance: userProvider.user!.balance),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
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
              const SizedBox(height: 10),
              transactionProvider.loading
                  ? const Center(
                      heightFactor: 10,
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        if (transactionProvider.transactions.isEmpty)
                          NoTransactionsWidget(
                            title: "No Recent Transactions",
                            centerText:
                                "Not recent transactions to show.\nStart by adding a deposit or withdrawal.",
                          ),
                        if (transactionProvider.transactions.isNotEmpty)
                          ...transactionProvider.transactions.take(10).map((
                            tx,
                          ) {
                            final isDeposit =
                                tx.type.toLowerCase() == "deposit";
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  isDeposit
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: isDeposit ? Colors.green : Colors.red,
                                ),
                                title: Text(tx.type),
                                subtitle: Text(formatDateTimeAmPm(tx.date)),
                                trailing: Text(
                                  "${isDeposit ? '+' : '-'}\$${tx.amount.abs().toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: isDeposit
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
