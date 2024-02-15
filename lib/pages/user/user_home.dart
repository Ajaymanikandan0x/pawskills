import 'package:flutter/material.dart';

import '../user/functions/main_functios_user.dart';
import 'functions/user_category.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
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
                child: bell(icon: Icons.notifications_none))
          ]),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: Column(
          children: [
            userCategoryList(context),
            const SizedBox(height: 40),
            Expanded(child: userPetLstView()),
          ],
        ),
      ),
    );
  }
}
