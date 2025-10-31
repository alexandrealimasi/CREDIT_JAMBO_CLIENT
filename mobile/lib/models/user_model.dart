class UserModel {
  final String id;
  final String name;
  final String email;
  final double balance;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'balance': balance,
    };
  }
}
