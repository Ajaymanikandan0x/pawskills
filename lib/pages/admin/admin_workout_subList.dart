import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/admin/admin_functions/training_function/workout_functions.dart';

class WorkoutSubList extends StatefulWidget {
  final String? workoutName;
  final String? energyLevel;

  WorkoutSubList({super.key, this.workoutName, this.energyLevel});

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
        title: Text('$widget.workoutName'),
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
                final workoutName = category['workoutName'];
                final workoutDetails = category['details'];
                print('firebase image $img');

                return workoutSubCard(
                    workoutImageUrl: img,
                    workoutName: workoutName,
                    workoutTime: workoutTime,
                    ontap: () {},
                    context: context,
                    delete: () {});
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

  Future<void> _fetchWorkout() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(widget.energyLevel)
          .collection('List')
          .doc(widget.workoutName)
          .collection('subList')
          .get();
      setState(() {
        workoutLists =
            querySnapshot.docs.map((doc) => doc['subList'] as String).toList();
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }
}
