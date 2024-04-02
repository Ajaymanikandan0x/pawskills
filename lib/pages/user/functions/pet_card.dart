import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main_functios_user.dart';

class PetCard extends StatefulWidget {
  final String listImg;
  final String petName;
  final String energyLevel;
  final String petdetails;
  final String? detailsPhoto;
  final String? life_expectancy;
  final VoidCallback? onTap;

  const PetCard({
    required this.listImg,
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
    String listImg = widget.listImg;
    return InkWell(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: Card(
          elevation: 5,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Apply border radius
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey[200]!], // Apply gradient
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    height: 110,
                    width: 110,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: listImg.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: listImg,
                              fit: BoxFit.cover,
                            )
                          : const Placeholder(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.petName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87, // Adjust text color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.energyLevel,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54, // Adjust text color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.petdetails,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87, // Adjust text color
                            ),
                          ),
                        ),
                      ),
                    ],
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
        ));
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
          'listPhoto': widget.listImg,
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
