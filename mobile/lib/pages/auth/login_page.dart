import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import '../../widgets/input_field.dart';
import '../../routes/app_routes.dart';
import '../../core/constants/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void validateAndLogin(UserProvider userProvider) {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      CustomDialog.infoDialog(
        context,
        title: "Missing Information",
        desc: "Please enter both email and password.",
      );
      return;
    }

    if (!email.contains("@") || !email.contains(".")) {
      CustomDialog.infoDialog(
        context,
        title: "Invalid Email",
        desc: "Please enter a valid email address.",
      );
      return;
    }

    if (password.length < 6) {
      CustomDialog.infoDialog(
        context,
        title: "Weak Password",
        desc: "Password must be at least 6 characters long.",
      );
      return;
    }

    EasyLoading.show(status: 'Logging in...');
    userProvider.signIn(
      onSuccess: (message) {
        EasyLoading.dismiss();
        CustomDialog.successDialog(
          context,
          title: "Login Successful",
          desc: message.toString(),
        );
        userProvider.resetValues();
        _emailController.clear();
        _passwordController.clear();
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      },
      onError: (message) {
        EasyLoading.dismiss();
        CustomDialog.errorDialog(context, title: "Login Failed", desc: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Icon(
                    Icons.savings_rounded,
                    color: AppColors.primary,
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome Back!",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login to manage your savings and goals.",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  InputField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => userProvider.setEmail(value.trim()),
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    label: "Password",
                    icon: Icons.lock_outline,
                    obscureText: obscurePassword,
                    onChanged: (value) =>
                        userProvider.setPassword(value.trim()),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => validateAndLogin(userProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.register,
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "© 2025 Credit Jambo Ltd",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
