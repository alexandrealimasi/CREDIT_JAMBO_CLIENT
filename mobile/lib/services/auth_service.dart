import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_endpoints.dart';

class AuthService {
  Future<http.Response> login(
    String email,
    String password,
    String deviceId,
  ) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'deviceId': deviceId,
      }),
    );
    return res;
  }

  Future<http.Response> register({
    required Map<String, dynamic> userData,
  }) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    return res;
  }
}
