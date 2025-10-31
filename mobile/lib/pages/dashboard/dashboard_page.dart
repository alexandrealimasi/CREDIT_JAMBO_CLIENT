import 'package:flutter/material.dart';
import 'package:mobile/pages/home/home_page.dart';
import 'package:mobile/pages/transactions/deposit_page.dart';
import 'package:mobile/pages/transactions/withdraw_page.dart';
import 'package:mobile/providers/transaction_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTransactions();
    });
  }

  fetchTransactions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    transactionProvider.setLoading(true);

    try {
      await transactionProvider.fetchTransactions(
        token: userProvider.token!,
        onError: () => transactionProvider.setLoading(false),
        onSuccess: () => transactionProvider.setLoading(false),
      );
    } catch (_) {
      transactionProvider.setLoading(false);
    }
  }

  final pages = const [HomePage(), DepositPage(), WithdrawPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) => setState(() => _currentIndex = index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: "Deposit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward),
            label: "Withdraw",
          ),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
