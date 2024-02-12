import 'package:flutter/material.dart';
import 'package:pawskills/pages/admin/adminFunctions/petImg.dart';
import '../user/functions/mainFunctios.dart';
import 'adminFunctions/adminFunction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              Flexible(child: categoryList(context)),
              SizedBox(height: 40),
              Expanded(child: petListView()),
            ],
          )),
    );
  }
}
