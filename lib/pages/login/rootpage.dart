import 'package:flutter/material.dart';
import 'package:pawskills/functions/Button.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              height: 50,
            ),
            button(text: 'Sing in'),
            const SizedBox(
              height: 20,
            ),
            button(text: 'Long in'),
          ],
        ),
      ),
    );
  }
}