import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'functions/Functions.dart';
import 'functions/formfield.dart';

class UserLogin extends StatelessWidget {
  UserLogin({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                'Hey there',
                style: TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome Back',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 40),
              form_field(
                  Hint_text: 'Email',
                  inputIcon: const Icon(Icons.email),
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z.]{2,}$")
                        .hasMatch(value)) {
                      return "Please enter a valid Email.";
                    }
                    return null;
                  },
                  controller: emailController),
              const SizedBox(height: 10),
              form_field(
                  Hint_text: 'Password',
                  inputIcon: const Icon(Icons.lock),
                  password: true,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!RegExp(
                            r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{4,}$")
                        .hasMatch(value)) {
                      return 'Enter minimum 4 letters';
                    }
                    return null;
                  },
                  controller: passwordController),
              const SizedBox(height: 30),
              InkWell(
                //add password reset option
                onTap: () {},
                child: const Text(
                  'Forgot your password?',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 100),
              //add home screen rout name
              button(
                  text: 'Login',
                  ontap: () async {
                    await _login(context);
                  },
                  width: 330),
              const SizedBox(height: 30),
              const Text(
                "or",
                style: TextStyle(fontSize: 18),
              ),
              const Divider(
                color: Colors.lightBlueAccent,
                thickness: 1,
                height: 5,
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account yet?'),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    //redirect to register page
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _login(BuildContext context) async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text;

      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the home page  upon successful login
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      // Handle any login errors
      if (kDebugMode) {
        print('Failed to sign in: $e');
      }
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in. Please check your credentials.'),
        ),
      );
    }
  }
}
