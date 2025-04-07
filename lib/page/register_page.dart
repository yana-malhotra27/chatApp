import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  //tap to go to login page
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  //register method
  void register(BuildContext context) {
    // get auth service
    final _auth = AuthService();
    //passwords match=> create user
    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
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

    //passwords don't match => tell user to fix
    else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            "REGISTER!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            "Email",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          //email textfield
          MyTextField(
            hintText: "Enter your Email",
            obscureText: false,
            controller: _emailController,
          ),
          const SizedBox(height: 30),
          //pw textfield
          Text(
            "Password",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          MyTextField(
            hintText: "Enter your Password",
            obscureText: true, //hides pw
            controller: _pwController,
          ),
          const SizedBox(height: 30),
          //cfpw textfield
          Text(
            "Confirm Password",
            textAlign: TextAlign.left,
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
          const SizedBox(height: 50),
          //login button
          MyButton(
            text: "Register",
            onTap: () => register(context),
          ),
          const SizedBox(height: 20),
          //register now
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
    );
  }
}
