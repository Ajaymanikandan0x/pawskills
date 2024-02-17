import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/functions/pet_card.dart';

import '../usr_pet_info.dart';

class UserPetView extends StatefulWidget {
  const UserPetView({super.key});

  @override
  State<UserPetView> createState() => _UserPetViewState();
}

class _UserPetViewState extends State<UserPetView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc('Dog')
          .collection('List')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.separated(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final category = documents[index].data() as Map<String, dynamic>;
            final img = category['listPhoto'];
            final petname = category['petName'];
            final energyLevel = category['energyLevel'];
            final petdetails = category['petDetails'];
            final life_expectancy = category['life_expectancy'];
            final detailsPhoto = category['detailsPhoto'];

            return PetCard(
                imgBase64: img,
                petName: petname,
                energyLevel: energyLevel,
                petdetails: petdetails,
                detailsPhoto: detailsPhoto,
                life_expectancy: life_expectancy,
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
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 8.0,
          ),
        );
      },
    );
  }
}
