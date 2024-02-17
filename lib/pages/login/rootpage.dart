import 'package:flutter/material.dart';

import 'functions/Functions.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                width: 300,
                child: Image.asset(
                  'assets/img/photos/log01.png',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              button(
                  text: 'Sing in',
                  ontap: () {
                    Navigator.pushNamed(context, '/register');
                  }),
              const SizedBox(
                height: 20,
              ),
              button(
                  text: 'Long in',
                  ontap: () {
                    Navigator.pushNamed(context, '/login');
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Long in as Gust',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 10),
                  InkWell(
                    //redirect to register page
                    onTap: () {
                      Navigator.pushNamed(context, '/skip');
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
      ),
    );
  }
}
