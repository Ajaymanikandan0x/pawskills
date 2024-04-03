import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/user/functions/main_functios_user.dart';
import 'package:pawskills/pages/user/user_training/training_home.dart';

class HomePetDetails extends StatefulWidget {
  final String imgBase64;
  final String detailImage;
  final String energyLevel;
  final String petName;
  final String petDetails;
  final String lifeExpectancy;

  const HomePetDetails({
    Key? key,
    required this.detailImage,
    required this.imgBase64,
    required this.petName,
    required this.energyLevel,
    required this.petDetails,
    required this.lifeExpectancy,
  }) : super(key: key);

  @override
  _HomePetDetailsState createState() => _HomePetDetailsState();
}

class _HomePetDetailsState extends State<HomePetDetails> {
  bool isWished = false;

  @override
  void initState() {
    super.initState();
    _checkWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final String detailImage = widget.detailImage;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: detailImage.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: detailImage,
                            fit: BoxFit.cover,
                          )
                        : const Placeholder(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    widget.petName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(Icons.upgrade_outlined, widget.energyLevel),
                    const SizedBox(width: 30),
                    _buildInfoItem(Icons.timelapse, widget.lifeExpectancy),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: wishButton(
                          isWished: isWished,
                          onTap: () {
                            _toggleWishlist();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.petDetails,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                    maxLines: null,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
                button(
                  text: 'Training',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserWorkoutList(
                          energyLevel: widget.energyLevel,
                        ),
                      ),
                    );
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
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
