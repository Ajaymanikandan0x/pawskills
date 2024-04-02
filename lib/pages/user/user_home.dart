import 'package:flutter/material.dart';
import 'functions/user_category.dart';
import 'functions/user_pet_view.dart';

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
        backgroundColor: Colors.blueAccent, // Change app bar color
        centerTitle: true,
        title: const Text(
          'Pet Registry',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18, top: 5),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white, // Change icon color
              ),
              onPressed: () {}, // Add functionality
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            userCategoryList(context), // Enhance category list
            const SizedBox(height: 25),
            const Expanded(
              child: UserPetView(),
            ),
          ],
        ),
      ),
    );
  }
}
