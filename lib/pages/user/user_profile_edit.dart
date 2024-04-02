import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';

import '../admin/admin_functions/petImg.dart';
import 'functions/hive/user_hive.dart';

class UserProfEdit extends StatefulWidget {
  const UserProfEdit({super.key});

  @override
  State<UserProfEdit> createState() => _UserProfEditState();
}

class _UserProfEditState extends State<UserProfEdit> {
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final lastNameController = TextEditingController();
  File? photo;
  String? photoBase64;

  @override
  void initState() {
    super.initState();
    // Fetch existing user data from Firestore and populate the text controllers
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => _getImage(context: context),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 100,
                  child: photoBase64 != null
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(photoBase64!),
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                          ),
                        )
                      : const Center(child: Text('Add image')),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _text('First Name'),
            const SizedBox(height: 10),
            nameField(controller: firstNameController, hintText: ' First name'),
            const SizedBox(height: 20),
            _text('Last Name'),
            const SizedBox(height: 20),
            nameField(
              hintText: 'Last name',
              controller: lastNameController,
            ),
            const SizedBox(height: 20),
            _text('Email Address'),
            const SizedBox(height: 10),
            nameField(
              hintText: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 80),
            Center(
              child: button(
                text: 'Save Changes',
                ontap: () {
                  _saveChanges();
                },
                width: 350,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage({required BuildContext context}) async {
    try {
      final picker = ImagePicker();
      final XFile? imageselect =
          await picker.pickImage(source: ImageSource.gallery);

      if (imageselect == null) {
        return; // Handle image selection cancellation gracefully
      }

      Uint8List imageBytes = await imageselect.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        photo = File(imageselect.path);
        photoBase64 = base64Image;
      });
    } catch (error) {
      print("Error picking image: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while selecting an image.'),
        ),
      );
    }
  }

  Widget _text(String text) => Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );

  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void fetchUserData() {
    FutureBuilder(
      future: _isConnected().then((isConnected) async {
        if (isConnected) {
          final User? user = FirebaseAuth.instance.currentUser;
          final currentUserDocRef =
              FirebaseFirestore.instance.collection('users').doc(user?.uid);

          try {
            final snapshot = await currentUserDocRef.get();
            if (snapshot.exists) {
              setState(() {
                firstNameController.text = snapshot.get('firstName') ?? '';
                lastNameController.text = snapshot.get('lastName') ?? '';
                emailController.text = snapshot.get('email') ?? '';
                photoBase64 = snapshot.get('photo') ?? '';
              });
            }
          } catch (error) {
            print('Error fetching user data from Firestore: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to fetch user data. Please try again.'),
              ),
            );
          }
        } else {
          final userDataBox = Hive.box<UserProfileData>('user_profile_data');
          final userProfileData = userDataBox.get('user_profile_data');

          if (userProfileData != null) {
            setState(() {
              firstNameController.text = userProfileData.firstName;
              lastNameController.text = userProfileData.lastName;
              emailController.text = userProfileData.email;
              photoBase64 = userProfileData.photoBase64;
            });
          }
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return snapshot.data ??
            Container(); // Return an empty container if data is null
      },
    );
  }

  void _saveChanges() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final currentUserDocRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    try {
      await currentUserDocRef.update({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'photo': photoBase64,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    } catch (error) {
      print("Error updating profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
    final userDataBox = Hive.box<UserProfileData>('user_profile_data');
    try {
      userDataBox.put(
        'user_profile_data',
        UserProfileData(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          photoBase64: photoBase64,
        ),
      );
    } catch (error) {
      print("Error updating profile in Hive: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile in Hive. Please try again.'),
        ),
      );
    }
  }
}
