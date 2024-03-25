import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'functions/hive/user_hive.dart';
import 'functions/trainig/user_saved_pets.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? profUrl;
  String? firstName;
  String? lastName;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'My Profile',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _kickOut(context);
                      },
                      icon: const Icon(Icons.exit_to_app))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 80,
                    child: profUrl != null && profUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.memory(
                              base64Decode(profUrl!),
                              fit: BoxFit.cover,
                              height: 200,
                              width: 200,
                            ),
                          )
                        : const Center(child: Text('Add image')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/user_prof_edt');
                      },
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${firstName ?? ''} ${lastName ?? ''}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(email ?? '', style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : getPetData(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    final currentUserid =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final snapshot = await currentUserid.get();

    if (snapshot.exists) {
      final firstname = snapshot.get('firstName');
      final userProf = snapshot.get('photo');
      final lastname = snapshot.get('lastName');
      final email_ = snapshot.get('email');

      setState(() {
        profUrl = userProf;
        firstName = firstname;
        lastName = lastname;
        email = email_;
        isLoading = false;
      });
    }

    if (!await isConnected()) {
      try {
        final box = await Hive.openBox<UserProfileData>('user_profile_data');
        final profileData = box.get('user_profile_data');
        if (profileData != null) {
          setState(() {
            profUrl = profileData.photoBase64;
            firstName = profileData.firstName;
            lastName = profileData.lastName;
            email = profileData.email;
          });
        }
      } catch (error) {
        print("Error fetching user data from Hive: $error");
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('Pass');
      await prefs.remove('User');
      await prefs.remove('role');

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
  }

  void _kickOut(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Exit',
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(color: Colors.red),
            ),
          ),
          content: const Text('Do you want to exit'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () => _signOut(context), child: const Text('Yes'))
          ],
        ),
      );
}
