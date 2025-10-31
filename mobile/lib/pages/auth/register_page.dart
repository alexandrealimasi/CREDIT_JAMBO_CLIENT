import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/widgets/custom_dialog.dart';
import '../../widgets/input_field.dart';
import '../../routes/app_routes.dart';
import '../../core/constants/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showPassword = false;
  bool showConfirmPassword = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void validateAndRegister(UserProvider userProvider) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      CustomDialog.infoDialog(
        context,
        title: "Missing Information",
        desc: "All fields are required.",
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

    if (password != confirmPassword) {
      CustomDialog.errorDialog(
        context,
        title: "Password Mismatch",
        desc: "Password and Confirm Password must match.",
      );
      return;
    }

    EasyLoading.show(status: 'Registering...');
    userProvider.signUp(
      onSuccess: (message) {
        EasyLoading.dismiss();
        CustomDialog.successDialog(
          context,
          title: "Registration Successful",
          desc: message.toString(),
        );
        userProvider.resetValues();
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmController.clear();
      },
      onError: (message) {
        EasyLoading.dismiss();
        CustomDialog.errorDialog(
          context,
          title: "Registration Failed",
          desc: message,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join us and start managing your savings easily.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        InputField(
                          controller: _nameController,
                          label: "Full Name",
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          onChanged: userProvider.setFullName,
                        ),
                        const SizedBox(height: 12),
                        InputField(
                          controller: _emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: userProvider.setEmail,
                        ),
                        const SizedBox(height: 12),
                        InputField(
                          controller: _passwordController,
                          onChanged: userProvider.setPassword,
                          keyboardType: TextInputType.text,
                          label: "Password",
                          obscureText: !showPassword,
                          icon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                          ),
                        ),
                        const SizedBox(height: 12),
                        InputField(
                          controller: _confirmController,
                          label: "Confirm Password",
                          obscureText: !showConfirmPassword,
                          onChanged: userProvider.setConfirmPassword,
                          icon: Icons.lock_reset_outlined,
                          keyboardType: TextInputType.text,
                          suffixIcon: IconButton(
                            icon: Icon(
                              showConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () => setState(
                              () => showConfirmPassword = !showConfirmPassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => validateAndRegister(userProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
