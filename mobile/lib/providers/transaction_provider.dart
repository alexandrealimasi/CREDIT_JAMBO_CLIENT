import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/transaction_service.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  bool get loading => _isLoading;
  List<TransactionModel> get transactions => _transactions;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setTransactions(List<TransactionModel> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void clear() {
    _transactions = [];
    notifyListeners();
  }

  Future<void> addDeposit({
    required double amount,
    required String note,
    required String token,
    required Function(dynamic) onSuccess,
    required Function(dynamic) onError,
  }) async {
    try {
      var response = await SavingsService().deposit(
        amount: amount,
        note: note,
        token: token,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log('Deposit Response: ${data["balance"]}');
        onSuccess(data);
      } else {
        onError('Failed to add deposit');
      }
    } catch (e) {
      log(e.toString());
      onError("An error occurred");
    }
  }

  Future<void> addWithdraw({
    required double amount,
    required String note,
    required String token,
    required Function(dynamic) onSuccess,
    required Function(dynamic) onError,
  }) async {
    try {
      var response = await SavingsService().withdraw(
        amount: amount,
        note: note,
        token: token,
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log('Withdraw Response: ${data["balance"]}');
        onSuccess(data);
      } else {
        onError(data);
      }
    } catch (e) {
      log(e.toString());
      onError("An error occurred");
    }
  }

  Future<void> fetchTransactions({
    required String token,
    required Function onSuccess,
    required Function onError,
  }) async {
    try {
      var response = await SavingsService().getHistory(token);
      var data = jsonDecode(response.body);
      if (data['transactions'] != null &&
          data['transactions'].isNotEmpty &&
          response.statusCode == 200) {
        List<TransactionModel> loadedTransactions = [];
        for (var tx in data['transactions']) {
          loadedTransactions.add(TransactionModel.fromJson(tx));
        }
        setTransactions(loadedTransactions);
        onSuccess();
      }
    } catch (e) {
      onError();
      log('Error fetching transactions: $e');
    }
  }
}
