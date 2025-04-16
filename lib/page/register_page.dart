import 'package:chatapp/services/auth/auth_service.dart';
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
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          title: Text(
            "Password is not confirmed correctly",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
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
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          title: Text(
            e.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget customTextField({
    required BuildContext context,
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(
          color: Theme.of(context).colorScheme.outline,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Widget customButton({
    required BuildContext context,
    required String text,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 70),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Text(
                "REGISTER!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 10),

              // Email
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
              customTextField(
                context: context,
                hintText: "Enter your Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Username
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
              customTextField(
                context: context,
                hintText: "Choose a Username",
                obscureText: false,
                controller: _usernameController,
              ),
              const SizedBox(height: 20),

              // Password
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
              customTextField(
                context: context,
                hintText: "Enter your Password",
                obscureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 20),

              // Confirm Password
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
              customTextField(
                context: context,
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPwController,
              ),
              const SizedBox(height: 36),

              // Register Button
              customButton(
                context: context,
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(height: 20),

              // Already a member?
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
