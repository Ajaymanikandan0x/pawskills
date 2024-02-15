import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/user/functions/main_functios_user.dart';

class UserPetInfo extends StatelessWidget {
  final String detailImage;
  final String energyLevel;
  final String petName;
  final String petDetails;
  final String lifeExpectancy;

  const UserPetInfo({
    super.key,
    required this.detailImage,
    required this.petName,
    required this.energyLevel,
    required this.petDetails,
    required this.lifeExpectancy,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    try {
      imageBytes = base64Decode(detailImage);
    } catch (e) {
      print('Error decoding image: $e');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // Align content to edges
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: AspectRatio(
                    aspectRatio: 16 / 13, // Maintain image aspect ratio
                    child: imageBytes != null
                        ? Image.memory(imageBytes, fit: BoxFit.cover)
                        : const Placeholder(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    petName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 29,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bell(icon: Icons.upgrade_outlined, width: 45, height: 45),
                      const SizedBox(width: 10),
                      Text(
                        energyLevel,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 10),
                      bell(icon: Icons.timelapse, height: 45, width: 45),
                      const SizedBox(width: 10),
                      Text(lifeExpectancy,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700])),
                      const SizedBox(width: 10),
                      wish(
                          width: 30,
                          height: 30,
                          icon_size: 18,
                          ontap: () {
                            // Navigator.pushNamed(context, '/wishlist');
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    petDetails,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 18),
                    maxLines: null,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
                button(text: 'Training', ontap: () {}, width: 350)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
