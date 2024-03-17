import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pet_info.dart';
import 'admin_function.dart';

class PetListView extends StatefulWidget {
  const PetListView({Key? key}) : super(key: key);

  @override
  State<PetListView> createState() => _PetListViewState();
}

class _PetListViewState extends State<PetListView> {
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
            final lifeExpectancy = category['life_expectancy'];
            final detailsPhoto = category['detailsPhoto'];
            final avgheight = category['height'];
            final avgweight = category['weight'];

            return petCard(
              context: context,
              listimg: img,
              petname: petname,
              energyLevel: energyLevel,
              petdetails: petdetails,
              ontap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPetInfo(
                          imgBase64: img,
                          detailImage: detailsPhoto,
                          petName: petname,
                          energyLevel: energyLevel,
                          petDetails: petdetails,
                          lifeExpectancy: lifeExpectancy,
                          avgHeight: avgheight,
                          avgWeight: avgweight,
                        )));
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

  Future<void> deletePet({required String petName}) async {
    final petId = petName;
    await FirebaseFirestore.instance
        .collection('categories')
        .doc('Dog')
        .collection('List')
        .doc(petId)
        .delete();
  }

  Widget petCard({
    required String listimg,
    required String petname,
    required String energyLevel,
    required String petdetails,
    required void Function()? ontap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: ontap,
      child: Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 110,
                width: 110,
                child: listimg.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: listimg,
                        fit: BoxFit.cover,
                      )
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
                      petname,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      energyLevel,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SingleChildScrollView(
                        child: Text(
                          petdetails,
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
              padding: const EdgeInsets.all(10),
              child: deleteIcon(
                context: context,
                petName: petname,
                deletePet: () {
                  deletePet(petName: petname);
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
