import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/auth_service.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  String? _fullName;
  String? _email;
  String? _password;
  String? _confirmPassword;

  UserModel? _user;
  String? _token;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  UserModel? get user => _user;
  String? get token => _token;
  double get balance => _user?.balance ?? 0;

  void setFullName(String fullName) {
    _fullName = fullName;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    notifyListeners();
  }

  void setUser(UserModel user, String token) {
    _user = user;
    _token = token;
    notifyListeners();
  }

  void updateBalance(double newBalance) {
    if (_user != null) {
      _user = UserModel(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        balance: newBalance,
      );
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID on Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? ''; // Unique ID on iOS
    } else {
      return "";
    }
  }

  resetValues() {
    _fullName = null;
    _email = null;
    _password = null;
    _confirmPassword = null;
    notifyListeners();
  }

  Future<void> signUp({
    required Function(dynamic) onSuccess,
    required Function(dynamic) onError,
  }) async {
    final idDevice = await getDeviceId();

    var response = await AuthService().register(
      userData: <String, dynamic>{
        'name': _fullName,
        'email': _email,
        'password': _password,
        "deviceId": idDevice.toString(),
      },
    );
    try {
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        onSuccess(responseData['message']);
      } else {
        onError(
          responseData['message'] ?? "Something went wrong.please try again.",
        );
      }
    } catch (e) {
      if (e.toString().contains("Too many requests, try again later")) {
        onError("Too many requests, try again later");
      } else {
        onError("Something went wrong, please try again.");
      }
    }
  }

  Future<void> signIn({
    required Function(dynamic) onSuccess,
    required Function(dynamic) onError,
  }) async {
    var responseBody = await AuthService().login(
      _email!,
      _password!,
      await getDeviceId(),
    );
    try {
      final response = jsonDecode(responseBody.body);
      if (response['token'] != null) {
        final userJson = response['user'];
        final decodedUser = UserModel.fromJson(userJson);
        setUser(decodedUser, response['token']);
        onSuccess(response['message']);
      } else if (responseBody.statusCode == 401 ||
          responseBody.statusCode == 403) {
        onError(response['message']);
      }
    } catch (e) {
      if (e.toString().contains("Too many requests, try again later")) {
        onError("Too many requests, try again later");
      } else {
        onError("Something went wrong, please try again.");
      }
    }
  }
}
