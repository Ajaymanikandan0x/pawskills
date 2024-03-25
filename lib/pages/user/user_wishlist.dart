import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pawskills/pages/user/usr_pet_info.dart';

import 'functions/pet_card.dart';
import 'functions/trainig/user_saved_pets.dart';

class UserWishlist extends StatelessWidget {
  const UserWishlist({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
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
            return _firebaseWishList();
          } else {
            // Network is not available, show Hive data
            return _hiveWishlist();
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
                  builder: (context) => UserPetInfo(
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
        final Box wishListBox = snapshot.data!;
        if (wishListBox.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        return ListView.separated(
          itemCount: wishListBox.length,
          itemBuilder: (context, index) {
            final petData = wishListBox.getAt(index) as Map<String, dynamic>;
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
                  builder: (context) => UserPetInfo(
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

  void _syncWithHive(List<DocumentSnapshot> wishlist) async {
    final Box wishListBox = await Hive.openBox('wishlist');

    for (final item in wishlist) {
      final petData = item.data();

      if (petData is Map<dynamic, dynamic>) {
        final petName = petData['petName'] as String?;

        if (petName != null) {
          final existingPet = wishListBox.values.firstWhere(
              (element) => element['petName'] == petName,
              orElse: () => null);

          if (existingPet == null) {
            // Pet is not in the wishlist, add it
            final img = petData['listPhoto'] as String?;
            final energyLevel = petData['energyLevel'] as String?;
            final petdetails = petData['petDetails'] as String?;
            final lifeExpectancy = petData['life_expectancy'] as String?;
            final detailsPhoto = petData['detailsPhoto'] as String?;

            if (img != null &&
                energyLevel != null &&
                petdetails != null &&
                lifeExpectancy != null &&
                detailsPhoto != null) {
              final Map<String, dynamic> petMap = {
                'petName': petName,
                'listPhoto': img,
                'energyLevel': energyLevel,
                'petDetails': petdetails,
                'life_expectancy': lifeExpectancy,
                'detailsPhoto': detailsPhoto,
              };
              wishListBox.add(petMap);
            } else {
              print('Error: Missing data for pet $petName.');
            }
          } else {
            print('Pet $petName is already in the wishlist.');
          }
        } else {
          print('Error: Missing petName for a pet.');
        }
      } else {
        print('Error: pet data is not in the expected format');
      }
    }
  }
}
