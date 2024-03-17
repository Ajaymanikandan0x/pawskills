import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/user_training/user_workout_details.dart';
import '../functions/trainig/trainig_functions.dart';

class UserWorkoutSubList extends StatelessWidget {
  final String workoutName;
  final String energyLevel;

  const UserWorkoutSubList({
    super.key,
    required this.workoutName,
    required this.energyLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(workoutName),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('WorkoutList')
              .doc(energyLevel)
              .collection('List')
              .doc(workoutName)
              .collection('subList')
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
                final category =
                    documents[index].data() as Map<String, dynamic>;
                final img = category['img'];
                final workoutTime = category['time'];
                final subWorkoutName = category['workoutName'];
                final workoutDetails = category['details'];
                final workoutCategory = category['category'];
                final workoutList = category['selectedList'];
                return userWorkoutSubCard(
                  workoutImageUrl: img,
                  workoutName: subWorkoutName,
                  workoutTime: workoutTime,
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserWorkoutDetails(
                              workoutName: subWorkoutName,
                              imgUrl: img,
                              details: workoutDetails,
                              time: workoutTime,
                              category: workoutCategory,
                              workoutList: workoutList),
                        ));
                  },
                  context: context,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                width: 8.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
