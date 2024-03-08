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
            ? Image.network(
                selectimg,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        text,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
      ),
    );

// ________________________pet_name-simple Text_form-field____________________________________________

Widget nameField(
        {String? hintText,
        TextEditingController? controller,
        String? Function(String?)? validate,
        int? maxLines = 1}) =>
    TextFormField(
      maxLines: maxLines,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
        filled: true,
        fillColor: const Color(0xffC9C0C0),
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
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
      controller: controller,
      validator: validate,
    );

Widget workoutImg({
  required void Function() onTap,
  required String text,
  String? selectedImage,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        width: 170,
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
        child: selectedImage != null
            ? Image.network(
                selectedImage,
                fit: BoxFit.cover,
              )
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
