import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/admin/admin_functions/admin_function.dart';
import '../admin_functions/training_function/add_trainig_list.dart';
import 'admin_workout_sublist.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  String selectedEnergyLevel = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category of Training'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AddCategoryDialog();
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              homePageCategory(
                text: 'High',
                ontap: () {
                  setState(() {
                    selectedEnergyLevel = 'High';
                  });
                },
              ),
              homePageCategory(
                text: 'Low',
                ontap: () {
                  setState(() {
                    selectedEnergyLevel = 'Low';
                  });
                },
              ),
              homePageCategory(
                text: 'Medium',
                ontap: () {
                  setState(() {
                    selectedEnergyLevel = 'Medium';
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('WorkoutList')
                  .doc(selectedEnergyLevel)
                  .collection('List')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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

                      return workoutCard(
                        categoryImg: listPhoto ?? '',
                        workoutList: workoutList ?? '',
                        workoutTime: workoutTime ?? '',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutSubList(
                                energyLevel: energyLevel,
                                workoutName: categoryName,
                              ),
                            ),
                          );
                        },
                        context: context,
                        categoryName: categoryName ?? '',
                        delete: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want to delete this category?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteCategory(categoryName,
                                          selectedEnergyLevel); // Pass selectedEnergyLevel
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        edit: () {
                          _editCategory(
                            categoryName ?? '',
                            workoutList ?? '',
                            workoutTime ?? '',
                            energyLevel ?? '',
                            listPhoto,
                            selectedEnergyLevel, // Pass selectedEnergyLevel
                            isEditing: true, // Add this line
                            oldCategoryName: categoryName, // Add this line
                          );
                        },
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

  void _editCategory(
    String categoryName,
    String workoutList,
    String workoutTime,
    String energyLevel,
    String? listPhoto,
    String selectedEnergyLevel, {
    bool? isEditing,
    String? oldCategoryName,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog(
          selectedEnergyLevel: selectedEnergyLevel,
          isEditing: isEditing,
          oldCategoryName: oldCategoryName,
          categoryName: categoryName,
          workoutList: workoutList,
          time: workoutTime,
          listPhoto: listPhoto,
        );
      },
    );
  }

  void _deleteCategory(String categoryName, String selectedEnergyLevel) async {
    try {
      // Access the collection within the correct scope
      final collection = FirebaseFirestore.instance
          .collection('WorkoutList')
          .doc(selectedEnergyLevel)
          .collection('List');

      // Query for the document with matching categoryName
      final querySnapshot =
          await collection.where('categoryName', isEqualTo: categoryName).get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No document found with categoryName: $categoryName');
        return; // Exit the function if no matching document found
      }

      // Delete the found document
      final document =
          querySnapshot.docs.first; // Assuming only one document matches
      await document.reference.delete();

      print('Document deleted: $categoryName');
    } catch (error) {
      print('Error deleting document: $error');
    }
  }
}
