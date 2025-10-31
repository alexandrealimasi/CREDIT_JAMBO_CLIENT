import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_endpoints.dart';

class SavingsService {
  Future<Map<String, dynamic>> getBalance(String token) async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.balance),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(res.body);
  }

  Future<http.Response> getHistory(String token) async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.history),
      headers: {'Authorization': 'Bearer $token'},
    );
    return res;
  }

  Future<http.Response> deposit({
    required double amount,
    required String note,
    required String token,
  }) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.deposit),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount, 'note': note}),
    );
    return res;
  }

  Future<http.Response> withdraw({
    required double amount,
    required String note,
    required String token,
  }) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.withdraw),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'amount': amount, 'note': note}),
    );
    return res;
  }
}
