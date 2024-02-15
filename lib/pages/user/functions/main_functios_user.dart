import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../usr_pet_info.dart';

// __________________________________Home_____________________________________________
Widget bell(
        {void Function()? onpressed,
        double width = 40,
        double height = 40,
        void Function()? ontap,
        IconData? icon}) =>
    InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: width,
        height: height,
        child: Icon(
          icon,
          color: Colors.deepPurple,
        ),
      ),
    );

// _______________________________pet_List_view_________________________________

Widget userPetLstView() => StreamBuilder<QuerySnapshot>(
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

            return petCard(
                context: context,
                imgBase64: img,
                petname: petname,
                energyLevel: energyLevel,
                petdetails: petdetails,
                ontap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserPetInfo(
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

// ___________________________________card_view_______________________________________

Widget petCard(
    {required String imgBase64,
    required String petname,
    required String energyLevel,
    required String petdetails,
    required void Function()? ontap,
    required BuildContext context}) {
  Uint8List? img;
  try {
    img = base64Decode(imgBase64);
  } catch (e) {
    print('Error decoding image: $e');
  }

  return InkWell(
    onTap: ontap,
    child: Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: img != null
                ? Image.memory(img, fit: BoxFit.cover)
                : const Placeholder(),
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
                        maxLines: 2,
                        petdetails,
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
            child: wish(
                icon: Icons.favorite_border_outlined,
                icon_size: 18,
                ontap: () {
                  // Navigator.pushNamed(context, '/wishlist');
                }),
          )
        ],
      ),
    ),
  );
}

// ___________________________wish______________________________________________

Widget wish(
        {double height = 30,
        double? width = 30,
        double icon_size = 10,
        IconData? icon,
        void Function()? ontap}) =>
    InkWell(
      onTap: ontap,
      child: Container(
          height: height,
          width: width,
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
            size: icon_size,
          )),
    );
