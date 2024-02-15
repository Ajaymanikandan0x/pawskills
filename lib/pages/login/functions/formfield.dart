import 'package:flutter/material.dart';

Widget form_field(
        {String? Hint_text,
        Icon? inputIcon,
        bool password = false,
        TextEditingController? controller,
        String? Function(String?)? validate}) =>
    TextFormField(
      decoration: InputDecoration(
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
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0),
            child: inputIcon,
          )),
      obscureText: password,
      controller: controller,
      validator: validate,
    );
// _______________________________pet_height and weight_________________________________________________

Widget pet_bmi(
        {required String Hint_text,
        required Icon inputIcon,
        required String hi_wi,
        TextEditingController? controller}) =>
    Row(
      children: [
        Expanded(
          child: form_field(
              Hint_text: Hint_text,
              inputIcon: inputIcon,
              controller: controller),
        ),
        const SizedBox(width: 3),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.purple[800],
          ),
          height: 50,
          width: 50,
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
