import 'package:flutter/material.dart';
import '../user/functions/main_functios_user.dart';
import 'admin_functions/admin_function.dart';

import 'admin_functions/pet_list_view.dart';

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
            'Pet Registry',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 18, top: 5),
                child: bell(icon: Icons.notifications_none))
          ]),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            categoryList(context),
            const SizedBox(height: 40),
            const Expanded(child: PetListView()),
          ],
        ),
      ),
    );
  }
}
