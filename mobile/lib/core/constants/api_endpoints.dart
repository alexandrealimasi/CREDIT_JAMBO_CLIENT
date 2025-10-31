import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['BASEURL'] ?? '';

  static final String login = "$baseUrl/auth/login";
  static final String register = "$baseUrl/auth/register";
  static final String deposit = "$baseUrl/transactions/deposit";
  static final String withdraw = "$baseUrl/transactions/withdraw";
  static final String balance = "$baseUrl/transactions/balance";
  static final String history = "$baseUrl/transactions/history";
}
