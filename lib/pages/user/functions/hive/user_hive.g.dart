// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileDataAdapter extends TypeAdapter<UserProfileData> {
  @override
  final int typeId = 1;

  @override
  UserProfileData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileData(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      email: fields[2] as String,
      photoBase64: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoBase64);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserWorkoutCardDataAdapter extends TypeAdapter<UserWorkoutCardData> {
  @override
  final int typeId = 0;

  @override
  UserWorkoutCardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserWorkoutCardData(
      categoryImg: fields[0] as String,
      workoutList: fields[1] as String,
      workoutTime: fields[2] as String,
      energyLevel: fields[3] as String,
      categoryName: fields[4] as String,
      isWished: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserWorkoutCardData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.categoryImg)
      ..writeByte(1)
      ..write(obj.workoutList)
      ..writeByte(2)
      ..write(obj.workoutTime)
      ..writeByte(3)
      ..write(obj.energyLevel)
      ..writeByte(4)
      ..write(obj.categoryName)
      ..writeByte(5)
      ..write(obj.isWished);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserWorkoutCardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PetDataAdapter extends TypeAdapter<PetData> {
  @override
  final int typeId = 2;

  @override
  PetData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetData(
      petName: fields[0] as String,
      petDetails: fields[1] as String,
      gender: fields[2] as String,
      weight: fields[3] as String,
      height: fields[4] as String,
      energyLevel: fields[5] as String,
      listPhotoBase64: fields[6] as String?,
      detailsPhotoBase64: fields[7] as String?,
      vaccinations: (fields[8] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, PetData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.petName)
      ..writeByte(1)
      ..write(obj.petDetails)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.energyLevel)
      ..writeByte(6)
      ..write(obj.listPhotoBase64)
      ..writeByte(7)
      ..write(obj.detailsPhotoBase64)
      ..writeByte(8)
      ..write(obj.vaccinations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WishlistItemAdapter extends TypeAdapter<WishlistItem> {
  @override
  final int typeId = 3;

  @override
  WishlistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItem(
      petName: fields[0] as String,
      listPhoto: fields[1] as String,
      energyLevel: fields[2] as String,
      petDetails: fields[3] as String,
      lifeExpectancy: fields[4] as String,
      detailsPhoto: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.petName)
      ..writeByte(1)
      ..write(obj.listPhoto)
      ..writeByte(2)
      ..write(obj.energyLevel)
      ..writeByte(3)
      ..write(obj.petDetails)
      ..writeByte(4)
      ..write(obj.lifeExpectancy)
      ..writeByte(5)
      ..write(obj.detailsPhoto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
