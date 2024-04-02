import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pawskills/pages/login/functions/Functions.dart';
import 'package:pawskills/pages/user/user_training/training_home.dart';

class UserPetInfo extends StatefulWidget {
  final String imgBase64;
  final String detailImage;
  final String energyLevel;
  final String petName;
  final String petDetails;
  final String gender;
  final List<dynamic>? vaccinations;

  const UserPetInfo({
    Key? key,
    required this.detailImage,
    required this.imgBase64,
    required this.petName,
    required this.energyLevel,
    required this.petDetails,
    required this.gender,
    this.vaccinations,
  }) : super(key: key);

  @override
  _UserPetInfoState createState() => _UserPetInfoState();
}

class _UserPetInfoState extends State<UserPetInfo> {
  @override
  Widget build(BuildContext context) {
    print(widget.vaccinations);
    Uint8List? img;
    try {
      img = base64Decode(widget.detailImage);
    } catch (e) {
      print('Error decoding image: $e');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 13,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: img != null
                        ? Image.memory(img, fit: BoxFit.cover)
                        : const Placeholder(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Center(
                    child: Text(
                      widget.petName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoItem(Icons.upgrade_outlined, widget.energyLevel),
                    _buildInfoItem(Icons.pets, widget.gender),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Icon(MdiIcons.needle),
                    ),
                    TextButton(
                      onPressed: () {
                        showVaccinationDialog(widget.vaccinations);
                      },
                      child: Text(
                        'Vaccination',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.petDetails,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                    maxLines: null,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
                button(
                  text: 'Training',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserWorkoutList(
                          energyLevel: widget.energyLevel,
                        ),
                      ),
                    );
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    final iconSize =
        MediaQuery.of(context).size.width * 0.05; // Adjust the factor as needed
    final textSize = MediaQuery.of(context).size.width * 0.04;
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: Colors.grey[700],
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  void showVaccinationDialog(List<dynamic>? vaccinations) {
    if (vaccinations == null || vaccinations.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Vaccination Data', style: _style),
            content: Text(
              'No vaccination data available.',
              style: _style,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Vaccination Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: vaccinations.map((vaccine) {
                return Text('${vaccine['name']}: ${vaccine['timePeriod']}',
                    style: _style);
              }).toList(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  final TextStyle _style = TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]);
}
