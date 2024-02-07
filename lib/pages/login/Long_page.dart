import 'package:flutter/material.dart';
import 'functions/Functions.dart';
import 'functions/formfield.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: <Widget>[
            const Text(
              'Hey there',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 10),
            const Text(
              'Welcome Back',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            SizedBox(height: 40),
            form_field(Hint_text: 'Email', inputIcon: const Icon(Icons.email)),
            const SizedBox(height: 10),
            form_field(
              Hint_text: 'Password',
              inputIcon: const Icon(Icons.lock),
              password: true,
            ),
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
            button(text: 'Login', routeName: '', context: context, width: 330),
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
      )),
    );
  }
}
