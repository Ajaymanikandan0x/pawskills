import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Text('Hey there,'),
          Text(
            'Create an Account',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          )
        ]),
      ),
    );
  }
}
