import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pawskills/pages/admin/admin_functions/admin_function.dart';
import 'package:pawskills/pages/admin/admin_functions/petImg.dart';

import '../../../login/functions/Functions.dart';

class AddCategoryDialog extends StatefulWidget {
  final TextEditingController? workoutList;
  final TextEditingController? timeController;
  final TextEditingController? categoryName;
  final String? selectedEnergyLevel;
  final String? selectimg;
  final bool? isEditing;
  final String? oldCategoryName;

  final void Function(
      TextEditingController? categoryName,
      TextEditingController? workoutList,
      TextEditingController? timeController,
      String selectedEnergyLevel,
      bool isEditing,
      String oldCategoryName,
      String updatedImage)? save;
  final Function()? pickImage;

  const AddCategoryDialog({
    Key? key,
    this.workoutList,
    this.timeController,
    this.categoryName,
    this.selectimg,
    this.pickImage,
    this.save,
    this.isEditing,
    this.oldCategoryName,
    this.selectedEnergyLevel,
  }) : super(key: key);

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  String? selectedEnergyLevel;
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    selectedEnergyLevel = widget.selectedEnergyLevel;
    _selectedImage = widget.selectimg;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Add Category')),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                  onTap: () async {
                    final img = await widget.pickImage!();
                    if (img != null) {
                      setState(() {
                        _selectedImage = img;
                      });
                    }
                  },
                  child:
                      petImg(text: 'add on image', selectimg: _selectedImage)),
            ),
            const SizedBox(height: 20),
            nameField(
              controller: widget.categoryName,
              hintText: 'Category Name',
            ),
            const SizedBox(height: 10),
            nameField(
              controller: widget.workoutList,
              hintText: 'Workout List',
            ),
            const SizedBox(height: 10),
            nameField(
              hintText: 'Workout Time',
              controller: widget.timeController,
            ),
            const SizedBox(height: 20),
            Center(
              child: DropdownButton<String>(
                value: selectedEnergyLevel,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedEnergyLevel = newValue;
                    });
                  }
                },
                items: <String>['High', 'Medium', 'Low']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Center(
              child: button(
                text: 'Save',
                ontap: () {
                  if (widget.save != null && selectedEnergyLevel != null) {
                    widget.save!(
                      widget.categoryName,
                      widget.workoutList,
                      widget.timeController,
                      selectedEnergyLevel!,
                      false, // Not editing
                      '', // No old category name for a new entry
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AddCategoryDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _selectedImage when the selectimg property changes
    if (widget.selectimg != oldWidget.selectimg) {
      setState(() {
        _selectedImage = widget.selectimg;
      });
    }
  }
}

// _____________________________________training_category_list__________________

Widget workoutCard({
  required String imgBase64,
  required String categoryName,
  required String workoutList,
  required String workoutTime,
  required void Function()? ontap,
  required BuildContext context,
  required void Function()? delete,
  required void Function()? edit,
}) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 70,
              width: 70,
              child: img != null
                  ? Image.memory(img, fit: BoxFit.cover)
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
                    categoryName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        workoutList,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        workoutTime,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                editButton(width: 35, height: 35, ontap: edit, icon_size: 18),
                SizedBox(height: 5),
                deleteButton(
                    width: 35, height: 35, ontap: delete, icon_size: 18),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
// _______________________level_________________________________________________
