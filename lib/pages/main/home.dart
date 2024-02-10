import 'package:flutter/material.dart';
import 'package:pawskills/pages/main/functions/mainFunctios.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[200],
          centerTitle: true,
          title: const Text(
            'PetRegistry',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 18, top: 5),
                child: bell())
          ]),
      body: Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  category(
                      text: 'Cats',
                      ontap: () {
                        Navigator.pushNamed(context, '/category');
                      }),
                  category(text: 'Dogs'),
                  category(text: 'Others'),
                  category(text: 'Add')
                ],
              )
            ],
          )),
    );
  }
}
