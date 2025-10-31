class TransactionModel {
  final String id;
  final String type; // "Deposit" or "Withdrawal"
  final double amount;
  final String date;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'Unknown',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'type': type, 'amount': amount, 'date': date};
  }
}
