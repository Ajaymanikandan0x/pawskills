import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/usr_pet_info.dart';

import 'functions/pet_card.dart';

class UserWishlist extends StatelessWidget {
  const UserWishlist({super.key});

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
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('wishlist')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final List<DocumentSnapshot> wishlist = snapshot.data!.docs;
              return ListView.separated(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final petData =
                      wishlist[index].data() as Map<String, dynamic>;
                  final img = petData['listPhoto'];
                  final petname = petData['petName'];
                  final energyLevel = petData['energyLevel'];
                  final petdetails = petData['petDetails'];
                  final life_expectancy = petData['life_expectancy'];
                  final detailsPhoto = petData['detailsPhoto'];
                  return PetCard(
                      imgBase64: img,
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
                                lifeExpectancy: life_expectancy)));
                      });
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: 8.0,
                ),
              );
            },
          ),
        ));
  }
}
