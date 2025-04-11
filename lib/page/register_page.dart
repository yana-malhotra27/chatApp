import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) async {
    final _auth = AuthService();

    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _pwController.text.trim();
    final confirmPassword = _confirmPwController.text.trim();

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "Password is not confirmed correctly",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    try {
      await _auth.signUpWithEmailPassword(email, password, username);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            e.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "REGISTER!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 40),

              // Email label
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              MyTextField(
                hintText: "Enter your Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 24),

              // Username label
              Text(
                "Username",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              MyTextField(
                hintText: "Choose a Username",
                obscureText: false,
                controller: _usernameController,
              ),
              const SizedBox(height: 24),

              // Password label
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              MyTextField(
                hintText: "Enter your Password",
                obscureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 24),

              // Confirm Password label
              Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPwController,
              ),
              const SizedBox(height: 36),

              // Register Button
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),

              const SizedBox(height: 10),

              // Already a member? Login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

