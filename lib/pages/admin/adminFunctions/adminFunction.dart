import 'package:flutter/material.dart';

Widget addnew(
        {void Function()? ontap,
        double height = 50,
        double width = 50,
        TextEditingController? controller,
        String? Hint_text,
        required IconData icon,
        String? Function(String?)? validate,
        bool readOnly = false}) =>
    Row(
      children: [
        Expanded(
            child: TextFormField(
          style: const TextStyle(fontSize: 20),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 20, top: 15, bottom: 15),
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
          readOnly: readOnly,
        )),
        SizedBox(width: 8.0),
        InkWell(
          onTap: ontap,
          child: Container(
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
            width: width,
            height: height,
            child: Icon(icon),
          ),
        ),
      ],
    );
