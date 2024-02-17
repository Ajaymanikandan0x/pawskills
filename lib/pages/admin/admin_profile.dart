import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import '../admin/admin_functions/petImg.dart';

class AdminProf extends StatefulWidget {
  const AdminProf({super.key});

  @override
  State<AdminProf> createState() => _AdminProfState();
}

class _AdminProfState extends State<AdminProf> {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
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

  Future<void> fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final currentUserDocRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final snapshot = await currentUserDocRef.get();
    if (snapshot.exists) {
      setState(() {
        firstNameController.text = snapshot.get('firstName') ?? '';
        lastNameController.text = snapshot.get('lastName') ?? '';
        emailController.text = snapshot.get('email') ?? '';
        photoBase64 = snapshot.get('photo') ?? '';
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen after signing out
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
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
  }
}
