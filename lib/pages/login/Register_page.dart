import 'package:flutter/material.dart';

import 'functions/Functions.dart';
import 'functions/formfield.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: SingleChildScrollView(
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
                  Hint_text: 'First Name', inputIcon: const Icon(Icons.person)),
              const SizedBox(
                height: 10,
              ),
              form_field(
                  Hint_text: 'Last Name', inputIcon: const Icon(Icons.person)),
              const SizedBox(
                height: 10,
              ),
              form_field(
                  Hint_text: 'Email', inputIcon: const Icon(Icons.email)),
              const SizedBox(
                height: 10,
              ),
              form_field(
                  Hint_text: 'Password',
                  inputIcon: const Icon(Icons.lock),
                  password: true),
              const SizedBox(
                height: 80,
              ),
              //going to the pet details page
              button(text: 'Register', routeName: '/RegPet', context: context),
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
    );
  }
}
