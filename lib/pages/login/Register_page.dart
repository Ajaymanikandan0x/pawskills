import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'functions/Functions.dart';
import 'functions/formfield.dart';

class Register extends StatelessWidget {
  Register({super.key});

  final formKey = GlobalKey<FormState>();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: formKey,
              child: Column(children: <Widget>[
                const Text(
                  'Hey there,',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 25,
                ),
                form_field(
                  Hint_text: 'First Name',
                  inputIcon: const Icon(Icons.person),
                  controller: firstname,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First name is required';
                    }
                    if (value.length < 4) {
                      return 'Full name must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                form_field(
                    Hint_text: 'Last Name',
                    inputIcon: const Icon(Icons.person),
                    controller: lastname,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 10,
                ),
                form_field(
                    Hint_text: 'Email',
                    inputIcon: const Icon(Icons.email),
                    controller: emailController,
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
                    }),
                const SizedBox(
                  height: 10,
                ),
                form_field(
                    Hint_text: 'Password',
                    inputIcon: const Icon(Icons.lock),
                    password: true,
                    controller: passwordController,
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
                    }),
                const SizedBox(
                  height: 80,
                ),
                //going to the pet details page
                button(
                  text: 'Register',
                  width: 350,
                  ontap: () async {
                    await _register(context);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
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
                    const Text('Already have a account?'),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      //redirect to login page
                      onTap: () {
                        Navigator.pushNamed(context, '/longin');
                      },
                      child: const Text(
                        'Long in',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        final String email = emailController.text.trim();
        final String password = passwordController.text;
        final String firstName = firstname.text.trim();
        final String lastName = lastname.text.trim();
        //create the user in fire base
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final User user = userCredential.user!;
        // save user details in firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        });
        Navigator.pushReplacementNamed(context, '/longin');
      } catch (e) {
        print('Error to add Email and password $e ');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Long in. Please check your credentials.'),
          ),
        );
      }
    }
  }
}
