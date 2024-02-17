import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/user/functions/main_functios_user.dart';

class UserPetInfo extends StatefulWidget {
  final String imgBase64;
  final String detailImage;
  final String energyLevel;
  final String petName;
  final String petDetails;
  final String lifeExpectancy;

  const UserPetInfo({
    Key? key,
    required this.detailImage,
    required this.imgBase64,
    required this.petName,
    required this.energyLevel,
    required this.petDetails,
    required this.lifeExpectancy,
  }) : super(key: key);

  @override
  _UserPetInfoState createState() => _UserPetInfoState();
}

class _UserPetInfoState extends State<UserPetInfo> {
  bool isWished = false;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    try {
      imageBytes = base64Decode(widget.detailImage);
    } catch (e) {
      print('Error decoding image: $e');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Align content to edges
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: AspectRatio(
                    aspectRatio: 16 / 13, // Maintain image aspect ratio
                    child: imageBytes != null
                        ? Image.memory(imageBytes, fit: BoxFit.cover)
                        : const Placeholder(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.petName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 29,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bell(icon: Icons.upgrade_outlined, width: 45, height: 45),
                      const SizedBox(width: 10),
                      Text(
                        widget.energyLevel,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 10),
                      bell(icon: Icons.timelapse, height: 45, width: 45),
                      const SizedBox(width: 10),
                      Text(widget.lifeExpectancy,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700])),
                      const SizedBox(width: 10),
                      wishButton(
                        isWished: isWished,
                        onTap: () {
                          _toggleWishlist();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.petDetails,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 18),
                    maxLines: null,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
                button(text: 'Training', ontap: () {}, width: 350)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleWishlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final wishlistRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist');

      if (isWished) {
        await wishlistRef.doc(widget.petName).delete();
      } else {
        // Save all pet data to the wishlist
        await wishlistRef.doc(widget.petName).set({
          'petName': widget.petName,
          'energyLevel': widget.energyLevel,
          'petDetails': widget.petDetails,
          'lifeExpectancy': widget.lifeExpectancy,
          'detailsPhoto': widget.detailImage,
          'listPhoto': widget.imgBase64
        });
      }

      setState(() {
        isWished = !isWished;
      });
    } catch (e) {
      print('Error toggling wishlist: $e');
    }
  }

  Future<void> _checkWishlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final wishlistDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(widget.petName)
          .get();

      setState(() {
        isWished = wishlistDoc.exists;
      });
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }
}
