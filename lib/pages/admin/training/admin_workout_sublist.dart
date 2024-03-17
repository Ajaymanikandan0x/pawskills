import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/admin/admin_functions/training_function/workout_functions.dart';
import 'package:pawskills/pages/admin/training/workout_details.dart';

class WorkoutSubList extends StatefulWidget {
  final String workoutName;
  final String energyLevel;

  WorkoutSubList(
      {super.key, required this.workoutName, required this.energyLevel});

  @override
  State<WorkoutSubList> createState() => _WorkoutSubListState();
}

class _WorkoutSubListState extends State<WorkoutSubList> {
  List<String> workoutLists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.workoutName),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('WorkoutList')
              .doc(widget.energyLevel)
              .collection('List')
              .doc(widget.workoutName)
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
                return workoutSubCard(
                    workoutImageUrl: img,
                    workoutName: subWorkoutName,
                    workoutTime: workoutTime,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetails(
                                workoutName: subWorkoutName,
                                imgUrl: img,
                                details: workoutDetails,
                                time: workoutTime,
                                category: workoutCategory,
                                workoutList: workoutList),
                          ));
                    },
                    context: context,
                    delete: () {
                      _delete(workoutName: subWorkoutName);
                    });
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

  void _delete({String? workoutName}) async {
    try {
      final collection = FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(widget.energyLevel)
          .collection('List')
          .doc(widget.workoutName)
          .collection('subList');

      final querySnapshot =
          await collection.where('workoutName', isEqualTo: workoutName).get();

      if (querySnapshot.docs.isEmpty) {
        print('No document found with categoryName: $workoutName');
        return;
      }
      // Delete the found document
      final document = querySnapshot.docs.first;
      await document.reference.delete();
      print('Document deleted: $workoutName');
    } catch (error) {
      print('Error deleting document: $error');
    }
  }
}
