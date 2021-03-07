import 'package:flutter/cupertino.dart';

class PersonalInfo {
  //Field names and values
  String docID;
  String email;
  String name;
  String age;
  String gender;
  String sexualOrientation;
  String veteranStatus;

  PersonalInfo(
      {this.docID,
      this.email,
      this.name,
      this.age,
      this.gender,
      this.sexualOrientation,
      this.veteranStatus});

  PersonalInfo.withEmail(@required String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NAME: name,
      AGE: age,
      GENDER: gender,
      SEXUAL_ORIENTATION: sexualOrientation,
      VETERAN_STATUS: veteranStatus
    };
  }

  static PersonalInfo deserialize(Map<String, dynamic> data, String docId) {
    return PersonalInfo(
      docID: docId,
      email: data[PersonalInfo.EMAIL],
      name: data[PersonalInfo.NAME],
      age: data[PersonalInfo.AGE],
      gender: data[PersonalInfo.GENDER],
      sexualOrientation: data[PersonalInfo.SEXUAL_ORIENTATION],
      veteranStatus: data[PersonalInfo.VETERAN_STATUS],
    );
  }

  static const AGE = 'age';
  static const EMAIL = 'email';
  static const NAME = 'name';
  static const GENDER = 'gender';
  static const SEXUAL_ORIENTATION = 'sexualOrientation';
  static const VETERAN_STATUS = 'veteranStatus';
  static const COLLECTION = 'personalInfo';
}
