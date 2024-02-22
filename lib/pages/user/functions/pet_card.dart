import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'main_functios_user.dart';

class PetCard extends StatefulWidget {
  final String imgBase64;
  final String petName;
  final String energyLevel;
  final String petdetails;
  final String? detailsPhoto;
  final String? life_expectancy;
  final VoidCallback? onTap;

  const PetCard({
    required this.imgBase64,
    required this.petName,
    required this.energyLevel,
    required this.petdetails,
    this.detailsPhoto,
    this.life_expectancy,
    this.onTap,
  });

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  bool isWished = false;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? img;
    try {
      img = base64Decode(widget.imgBase64);
    } catch (e) {
      print('Error decoding image: $e');
    }

    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
              child: SizedBox(
                height: 110,
                width: 110,
                child: img != null
                    ? Image.memory(img, fit: BoxFit.cover)
                    : const Placeholder(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.petName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.energyLevel,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.petdetails,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: wishButton(
                isWished: isWished,
                onTap: () {
                  setState(() {
                    isWished = isWished;
                  });
                  _toggleWishlist(widget.petName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleWishlist(String petName) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist');

    try {
      if (isWished) {
        await wishlistRef.doc(petName).delete();
      } else {
        await wishlistRef.doc(petName).set({
          'petName': widget.petName,
          'energyLevel': widget.energyLevel,
          'petDetails': widget.petdetails,
          'listPhoto': widget.imgBase64,
          'life_expectancy': widget.life_expectancy,
          'detailsPhoto': widget.detailsPhoto
          // Add more fields as needed
        });
      }

      setState(() {
        // Update isWished after the Firestore operation completes
        isWished = !isWished;
        print(isWished);
      });
    } catch (e) {
      print('Error toggling wishlist: $e');
      // Handle error here, e.g., show a snackbar or retry logic
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
