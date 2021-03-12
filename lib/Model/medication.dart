import 'package:flutter/cupertino.dart';

class Medication {
  static const COLLECTION = 'medicationInfo';
  static const EMAIL = 'email';
  static const MEDNAME = 'medName';
  static const MEDCOUNT = 'medCount';
  static const DOSEAMT = 'doseAmt';
  static const TIMESDAILY = 'timesDaily';

  // Field names and values
  String docId;
  String email;
  String medName;
  String medCount;
  String doseAmt; // in mg
  String timesDaily; // how many doses per day

  Medication({
    this.docId,
    this.email,
    this.medName,
    medCount = 0,
    this.doseAmt,
    this.timesDaily,
  });

  Medication.withEmail(@required String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: this.email,
      MEDNAME: medName,
      MEDCOUNT: medCount,
      DOSEAMT: doseAmt,
      TIMESDAILY: timesDaily,
    };
  }

  static Medication deserialize(Map<String, dynamic> data, String docId) {
    return Medication(
        docId: docId,
        email: data[Medication.EMAIL],
        medName: data[Medication.MEDNAME],
        medCount: data[Medication.MEDCOUNT],
        doseAmt: data[Medication.DOSEAMT],
        timesDaily: data[Medication.TIMESDAILY]);
  }

    @override
  String toString() {
    return 'Medication: {medName: ${medName}}';
  }
}
