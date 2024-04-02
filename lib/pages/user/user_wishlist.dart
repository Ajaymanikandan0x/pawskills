import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pawskills/pages/user/usr_pet_info.dart';
import 'functions/home_pet_details.dart';
import 'functions/pet_card.dart';
import 'functions/trainig/user_saved_pets.dart';

class UserWishlist extends StatelessWidget {
  const UserWishlist({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          'Wishlist',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<bool>(
        future: isConnected(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!) {
            // Network is available, show Firebase data
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: _firebaseWishList(),
            );
          } else {
            // Network is not available, show Hive data
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: _hiveWishlist(),
            );
          }
        },
      ),
    );
  }

  Widget _firebaseWishList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('wishlist')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        final List<DocumentSnapshot> wishlist = snapshot.data!.docs;
        _syncWithHive(wishlist); // Sync Firebase data with Hive
        return ListView.separated(
          itemCount: wishlist.length,
          itemBuilder: (context, index) {
            final petData = wishlist[index].data() as Map<String, dynamic>;
            final img = petData['listPhoto'];
            final petname = petData['petName'];
            final energyLevel = petData['energyLevel'];
            final petdetails = petData['petDetails'];
            final lifeExpectancy = petData['life_expectancy'];
            final detailsPhoto = petData['detailsPhoto'];
            return PetCard(
              listImg: img,
              petName: petname,
              energyLevel: energyLevel,
              petdetails: petdetails,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomePetDetails(
                    imgBase64: img,
                    detailImage: detailsPhoto,
                    petName: petname,
                    energyLevel: energyLevel,
                    petDetails: petdetails,
                    lifeExpectancy: lifeExpectancy,
                  ),
                ));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 8.0,
          ),
        );
      },
    );
  }

  Widget _hiveWishlist() {
    return FutureBuilder<Box>(
      future: Hive.openBox('wishlist'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final Box? wishListBox = snapshot.data;
        if (wishListBox == null || wishListBox.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        return ListView.separated(
          itemCount: wishListBox.length,
          itemBuilder: (context, index) {
            final petData = wishListBox.getAt(index) as Map?;
            if (petData == null) {
              return const SizedBox();
            }
            final img = petData['listPhoto'];
            final petName = petData['petName'];
            final energyLevel = petData['energyLevel'];
            final petDetails = petData['petDetails'];
            final lifeExpectancy = petData['life_expectancy'];
            final detailsPhoto = petData['detailsPhoto'];

            return PetCard(
              listImg: img,
              petName: petName,
              energyLevel: energyLevel,
              petdetails: petDetails,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPetInfo(
                    imgBase64: img,
                    detailImage: detailsPhoto,
                    petName: petName,
                    energyLevel: energyLevel,
                    petDetails: petDetails,
                    gender: lifeExpectancy,
                  ),
                ));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 8.0,
          ),
        );
      },
    );
  }

  void _syncWithHive(List<DocumentSnapshot> wishlist) async {
    final Box wishListBox = await Hive.openBox('wishlist');
    for (final item in wishlist) {
      final petData = item.data() as Map<String, dynamic>;
      final petName = petData['petName'] as String;
      final img = petData['listPhoto'] as String;
      final energyLevel = petData['energyLevel'] as String;
      final petDetails = petData['petDetails'] as String;
      final lifeExpectancy = petData['life_expectancy'] as String;
      final detailsPhoto = petData['detailsPhoto'] as String;

      // Check if the item exists in Hive, if not, add it
      if (!wishListBox.values.any((element) => element['petName'] == petName)) {
        final http.Response response = await http.get(Uri.parse(detailsPhoto));
        if (response.statusCode == 200) {
          final String base64Image = base64Encode(response.bodyBytes);
          print('----------------------------- $base64Image');
          final Map<String, dynamic> petMap = {
            'petName': petName,
            'listPhoto': img,
            'energyLevel': energyLevel,
            'petDetails': petDetails,
            'life_expectancy': lifeExpectancy,
            'detailsPhoto': base64Image, // Save image as base64 string
          };
          wishListBox.add(petMap);
        } else {
          print('Failed to fetch detailed image for $petName');
        }
      }
    }
  }
}
