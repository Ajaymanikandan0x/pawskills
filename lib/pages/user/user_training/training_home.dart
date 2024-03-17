import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:pawskills/pages/user/user_training/user_workout_sublist.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../functions/hive/user_hive.dart';
import '../functions/trainig/trainig_functions.dart';

class UserWorkoutList extends StatefulWidget {
  final String energyLevel;

  const UserWorkoutList({required this.energyLevel, Key? key})
      : super(key: key);

  @override
  State<UserWorkoutList> createState() => _UserWorkoutListState();
}

class _UserWorkoutListState extends State<UserWorkoutList> {
  late Box<UserWorkoutCardData> workoutCardBox;
  Map<String, bool> wishListStatus = {};

  @override
  void initState() {
    super.initState();
    // Open Hive box
    openHiveBox();
    _checkWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category of Training'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('WorkoutList')
                  .doc(widget.energyLevel)
                  .collection('List')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Lottie.asset('assets/json/loading.json'));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ListView.separated(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final category =
                          documents[index].data() as Map<String, dynamic>;
                      final categoryName = category['categoryName'];
                      final workoutList = category['workoutList'];
                      final workoutTime = category['workoutTime'];
                      final energyLevel = category['selectedEnergyLevel'];
                      final listPhoto = category['listPhoto'];

                      bool isWished = wishListStatus.containsKey(categoryName)
                          ? wishListStatus[categoryName]!
                          : false;

                      return userWorkoutCard(
                        categoryImg: listPhoto ?? '',
                        workoutList: workoutList ?? '',
                        workoutTime: workoutTime ?? '',
                        ontap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserWorkoutSubList(
                                  energyLevel: energyLevel,
                                  workoutName: categoryName,
                                ),
                              ));
                        },
                        context: context,
                        categoryName: categoryName ?? '',
                        wishList: () {
                          setState(() {
                            isWished = !isWished;
                            wishListStatus[categoryName] = isWished;
                          });
                          print('__________________________$isWished');
                          _wishList(UserWorkoutCardData(
                            categoryImg: listPhoto ?? '',
                            workoutList: workoutList ?? '',
                            workoutTime: workoutTime ?? '',
                            energyLevel: energyLevel ?? '',
                            categoryName: categoryName ?? '',
                            isWished: isWished,
                          ));
                        },
                        isWished: isWished,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 8.0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _wishList(UserWorkoutCardData? cardData) async {
    if (cardData != null) {
      final bool newWishedState = cardData.isWished;
      print(
          'After toggling: ${cardData.isWished}___&&&&&________$newWishedState');
      // Update Firestore
      final user = FirebaseAuth.instance.currentUser;
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user?.uid);
      if (newWishedState) {
        await userDocRef
            .collection('wishlist')
            .doc('workout')
            .collection('List')
            .doc(cardData.categoryName)
            .set({
          'categoryName': cardData.categoryName,
          'workoutList': cardData.workoutList,
          'workoutTime': cardData.workoutTime,
          'selectedEnergyLevel': cardData.energyLevel,
          'listPhoto': cardData.categoryImg,
        });
      } else {
        // Remove document from the 'wishListTraining' collection
        await userDocRef
            .collection('wishlist')
            .doc('workout')
            .collection('List')
            .doc(cardData.categoryName)
            .delete();
      }
      // Add data to Hive box
      if (newWishedState) {
        addDataToHiveBox(cardData);
      } else {
        removeDataFromHiveBox(cardData.categoryName);
      }
    }
  }

  Future<void> addDataToHiveBox(UserWorkoutCardData newData) async {
    try {
      // Add data to the Hive box
      await workoutCardBox.put(newData.categoryName, newData);
      print('Adding data to Hive box: $newData ___+____+__+_________+______');
    } catch (error) {
      print('Error adding data to Hive box: $error');
    }
  }

  Future<void> removeDataFromHiveBox(String categoryName) async {
    try {
      // Remove data from the Hive box
      await workoutCardBox.delete(categoryName);
      print(
          'Removing data from Hive box: $categoryName ________________________');
    } catch (error) {
      print('Error removing data from Hive box: $error');
    }
  }

  Future<void> openHiveBox() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    // Hive.registerAdapter(UserWorkoutCardDataAdapter());
    workoutCardBox =
        await Hive.openBox<UserWorkoutCardData>('workout_card_data');
  }

  Future<void> _checkWishlist() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final wishlistDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc('workout')
          .collection('List')
          .get();

      final documents = wishlistDoc.docs;
      Map<String, bool> tempWishListStatus = {};

      for (var doc in documents) {
        tempWishListStatus[doc['categoryName']] = true;
      }
      setState(() {
        wishListStatus = tempWishListStatus;
      });
    } catch (e) {
      print('Error checking wishlist: $e');
    }
  }
}
