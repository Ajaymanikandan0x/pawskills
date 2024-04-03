import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'functions/hive/user_hive.dart';
import 'functions/main_functios_user.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        // Match previous color
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Roboto', // Use custom font
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState
                  ?.openDrawer(); // Call method to show settings dialog
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      drawer: buildDrawer(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      maxRadius: 80,
                      child: profUrl != null && profUrl!.isNotEmpty
                          ? ClipOval(
                              child: Image.memory(
                                base64Decode(profUrl!),
                                fit: BoxFit.cover,
                                height: 160,
                                width: 160,
                              ),
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 160,
                              color: Colors.grey[400],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/user_prof_edt');
                      },
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${firstName ?? ''} ${lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  email ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
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
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            if (snapshot.exists) {
              try {
                final firstname = snapshot.get('firstName');
                final userProf = snapshot.get('photo');
                final lastname = snapshot.get('lastName');
                final email_ = snapshot.get('email');

                final box =
                    await Hive.openBox<UserProfileData>('user_profile_data');
                await box.put(
                    'profile_data',
                    UserProfileData(
                      photoBase64: userProf,
                      firstName: firstname,
                      lastName: lastname,
                      email: email_,
                    ));

                setState(() {
                  profUrl = profileData.photoBase64;
                  firstName = profileData.firstName;
                  lastName = profileData.lastName;
                  email = profileData.email;
                });
              } catch (e) {
                print(e);
              }
            }
          }
        }
      } catch (error) {
        print("Error fetching user data from Hive: $error");
      }
    }
  }
}
