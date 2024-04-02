import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../usr_pet_info.dart';
import '../hive/user_hive.dart';
import '../user_local_pet_card.dart';

Future<bool> isConnected() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

Widget getPetData() {
  return FutureBuilder<Widget>(
    future: isConnected().then((isConnected) {
      if (isConnected) {
        // If there is internet connectivity, return data from Firebase
        return _getPetDataFromFirebase();
      } else {
        // If there is no internet connectivity, return data from local database
        return _getPetDataFromLocal();
      }
    }),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      return snapshot.data ??
          Container(); // Return an empty container if data is null
    },
  );
}

Widget _getPetDataFromFirebase() => StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('wishlist')
          .doc('user_pet')
          .collection('List')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<DocumentSnapshot> wishlist = snapshot.data!.docs;
        return ListView.separated(
          itemCount: wishlist.length,
          itemBuilder: (context, index) {
            final petData = wishlist[index].data() as Map<String, dynamic>;
            final img = petData['listPhoto'];
            final petname = petData['petName'];
            final energyLevel = petData['energyLevel'];
            final petdetails = petData['petDetails'];
            final gender = petData['gender'];
            final detailsPhoto = petData['detailsPhoto'];
            final vaccination = petData['vaccinations'];
            return LocalPetCard(
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
                            gender: gender,
                            vaccinations: vaccination,
                          )));
                });
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 8.0,
          ),
        );
      },
    );

Future<List<PetData>> _getPetDataFromHive() async {
  try {
    // Initialize Hive and get the application documents directory
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Open the Hive box
    final box = await Hive.openBox<PetData>('user_pets');

    // Retrieve all pet data from the Hive box
    final List<PetData> petDataList = box.values.toList();

    return petDataList;
  } catch (error) {
    print('Error fetching data from Hive: $error');
    return [];
  }
}

Widget _getPetDataFromLocal() => FutureBuilder<List<PetData>>(
      future: _getPetDataFromHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final List<PetData> petDataList = snapshot.data!;
        return ListView.builder(
          itemCount: petDataList.length,
          itemBuilder: (context, index) {
            final PetData petData = petDataList[index];
            return LocalPetCard(
              imgBase64: petData.listPhotoBase64 ?? '',
              petName: petData.petName,
              energyLevel: petData.energyLevel,
              petdetails: petData.petDetails,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserPetInfo(
                    imgBase64: petData.listPhotoBase64 ?? '',
                    detailImage: petData.detailsPhotoBase64 ?? '',
                    petName: petData.petName,
                    energyLevel: petData.energyLevel,
                    petDetails: petData.petDetails,
                    gender: petData.gender,
                    vaccinations: petData.vaccinations,
                  ),
                ));
              },
            );
          },
        );
      },
    );
