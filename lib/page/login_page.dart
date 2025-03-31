import 'package:chatapp/components/my_button.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
//flow
//Enter email and password.
//Tap a "Login" button to log in.
//Navigate to the registration page.
class LoginPage extends StatelessWidget {
  //email and pw text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  //tap to go to register page
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  //login method
  void login(BuildContext context) async {
    //auth service
    final authService = AuthService();

    //try login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _pwController.text,
      );
    }

    //catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(
            e.toString(),
            style: TextStyle(
              color: Colors.red,
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
          //welcomeback message
          Text(
            "LOGIN!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 60),
          Text("Email",
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
          Text("Password",
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
          const SizedBox(height: 50),
          //login button
          MyButton(
            text: "Login",
            onTap: () => login(context),
          ),
          const SizedBox(height: 20),
          //register now
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New member? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  "Register now",
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
