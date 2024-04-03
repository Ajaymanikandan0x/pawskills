import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';

part 'user_hive.g.dart';

@HiveType(typeId: 1)
class UserProfileData extends HiveObject {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? photoBase64;

  UserProfileData({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.photoBase64,
  });
}

// ______________________workOut________________________________________________

@HiveType(typeId: 0)
class UserWorkoutCardData extends HiveObject {
  @HiveField(0)
  final String categoryImg;

  @HiveField(1)
  final String workoutList;

  @HiveField(2)
  final String workoutTime;

  @HiveField(3)
  final String energyLevel;

  @HiveField(4)
  final String categoryName;

  @HiveField(5)
  bool isWished;

  UserWorkoutCardData({
    required this.categoryImg,
    required this.workoutList,
    required this.workoutTime,
    required this.energyLevel,
    required this.categoryName,
    required this.isWished,
  });
}

// ______________________________user_pet_____________________
@HiveType(typeId: 2)
class PetData {
  @HiveField(0)
  String petName;

  @HiveField(1)
  String petDetails;

  @HiveField(2)
  String gender;

  @HiveField(3)
  String weight;

  @HiveField(4)
  String height;

  @HiveField(5)
  String energyLevel;

  @HiveField(6)
  String? listPhotoBase64;

  @HiveField(7)
  String? detailsPhotoBase64;

  @HiveField(8)
  late List<Map<String, String>> vaccinations;

  PetData({
    required this.petName,
    required this.petDetails,
    required this.gender,
    required this.weight,
    required this.height,
    required this.energyLevel,
    this.listPhotoBase64,
    this.detailsPhotoBase64,
    required this.vaccinations,
  });
}

// __________________________________user_pet_wishlist__________________________

@HiveType(typeId: 3)
class WishlistItem extends HiveObject {
  @HiveField(0)
  late String petName;

  @HiveField(1)
  late String listPhoto;

  @HiveField(2)
  late String energyLevel;

  @HiveField(3)
  late String petDetails;

  @HiveField(4)
  late String lifeExpectancy;

  @HiveField(5)
  late String detailsPhoto;

  WishlistItem({
    required this.petName,
    required this.listPhoto,
    required this.energyLevel,
    required this.petDetails,
    required this.lifeExpectancy,
    required this.detailsPhoto,
  });
}
