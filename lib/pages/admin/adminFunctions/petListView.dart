import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:pawskills/pages/admin/adminFunctions/petImg.dart';

class PetListView extends StatelessWidget {
  const PetListView({super.key});

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

        return SizedBox(
          height: 40,
          child: ListView.separated(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final category = documents[index].data() as Map<String, dynamic>;
              final img = category['listPhoto'];
              final petname = category['petName'];
              final energyLevel = category['energyLevel'];
              final petdetails = category['petDetails'];
              return petCard(
                  imgBase64: img,
                  petname: petname,
                  energyLevel: energyLevel,
                  petdetails: petdetails);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              width: 8.0,
            ),
          ),
        );
      },
    );
  }
}
