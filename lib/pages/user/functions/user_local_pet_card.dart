import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pawskills/pages/admin/admin_functions/admin_function.dart';
import 'hive/user_hive.dart';

class LocalPetCard extends StatefulWidget {
  final String imgBase64;
  final String petName;
  final String energyLevel;
  final String petdetails;
  final String? detailsPhoto;
  final String? life_expectancy;
  final VoidCallback? onTap;

  const LocalPetCard({
    required this.imgBase64,
    required this.petName,
    required this.energyLevel,
    required this.petdetails,
    this.detailsPhoto,
    this.life_expectancy,
    this.onTap,
  });

  @override
  _LocalPetCardState createState() => _LocalPetCardState();
}

class _LocalPetCardState extends State<LocalPetCard> {
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
              child: deleteButton(
                ontap: () {
                  _deleteData(widget.petName);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _deleteData(String uid) async {
    await deleteDataFromHive(uid);
    await deleteDataFromFirestore(uid);
    setState(() {});
  }

  Future<void> deleteDataFromFirestore(String uid) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc('user_pet')
        .collection('List');

    try {
      await wishlistRef.doc(uid).delete();
      print('Data with UID $uid deleted successfully from Firestore.');
    } catch (e) {
      print('Error deleting data from Firestore: $e');
    }
  }

  Future<void> deleteDataFromHive(String petName) async {
    // Open the Hive box
    final box = await Hive.openBox<PetData>('user_pets');

    // Find the index of the item with the given petName
    final index =
        box.values.toList().indexWhere((data) => data.petName == petName);

    if (index != -1) {
      await box.deleteAt(index);
      print('Data with petName $petName deleted from Hive.');
    } else {
      print('Data with petName $petName not found in Hive.');
    }
  }
}
