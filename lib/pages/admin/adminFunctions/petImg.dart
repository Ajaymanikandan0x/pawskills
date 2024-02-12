import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ____________________________imgadd_______________________________________
Widget petImg({
  void Function()? ontap,
  required String text,
  String? selectimg,
}) =>
    InkWell(
      onTap: ontap,
      child: Container(
        width: 130,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: selectimg != null
            ? Image.memory(
                base64Decode(selectimg), // Decode base64 string to bytes
                fit: BoxFit.cover, // Adjust this to fit your UI requirements
              ) // Display the selected image
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ), // Placeholder icon
              ),
      ),
    );

// ________________________pet_name-____________________________________________

Widget nameField(
        {String? Hint_text,
        TextEditingController? controller,
        String? Function(String?)? validate,
        int? maxLines = 1}) =>
    TextFormField(
      maxLines: maxLines,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
        filled: true,
        fillColor: Colors.white54,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Colors.white54,
            width: 2.0,
          ),
        ),
        hintText: Hint_text,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
      controller: controller,
      validator: validate,
    );

// _______________________________pet_List_view_____________________________________

Widget petListView() => StreamBuilder<QuerySnapshot>(
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
            return petCard(
                imgBase64: img,
                petname: petname,
                energyLevel: energyLevel,
                petdetails: petdetails);
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            width: 8.0,
          ),
        );
      },
    );

// ___________________________________card_view_______________________________________

Widget petCard({
  required String imgBase64,
  required String petname,
  required String energyLevel,
  required String petdetails,
}) {
  Uint8List? img;
  try {
    img = base64Decode(imgBase64);
  } catch (e) {
    print('Error decoding image: $e');
  }

  return Card(
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
        Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: const Icon(Icons.edit)),
      ],
    ),
  );
}
