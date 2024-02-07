import 'package:flutter/material.dart';

Widget form_field(
        {required String Hint_text,
        required Icon inputIcon,
        bool password = false}) =>
    TextFormField(
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white54,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
          hintText: Hint_text,
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0),
            child: inputIcon,
          )),
      obscureText: password,
    );
// _______________________________pet_height and weight_________________________________________________

Widget pet_bmi({
  required String Hint_text,
  required Icon inputIcon,
  required String hi_wi,
}) =>
    Row(
      children: [
        Expanded(
          child: form_field(Hint_text: Hint_text, inputIcon: inputIcon),
        ),
        const SizedBox(width: 3),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.purple[800],
          ),
          height: 56,
          width: 58,
          child: Center(
            child: Text(
              hi_wi,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
