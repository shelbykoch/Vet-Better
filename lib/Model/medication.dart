

import 'package:flutter/cupertino.dart';

class Medication {
  static const COLLECTION = 'medicationInfo';
  static const EMAIL = 'email';
  static const MEDNAME = 'medName';
  static const DOSEAMT = 'doseAmt';
  static const TIMESDAILY = 'timesDaily';
  static const REFILLDATE = 'refillDate';

  // Field names and values
  String docId;
  String email;
  String medName;
  String doseAmt; // in mg
  String timesDaily; // how many doses per day
  String refillDate;

  Medication(
      {this.docId,
      this.email,
      this.medName,
      this.doseAmt,
      this.timesDaily,
      this.refillDate});

  Medication.withEmail(@required String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: this.email,
      MEDNAME: medName,
      DOSEAMT: doseAmt,
      TIMESDAILY: timesDaily,
      REFILLDATE: refillDate,
    };
  }

  static Medication deserialize(Map<String, dynamic> data, String docId) {
    return Medication(
      docId: docId,
      email: data[Medication.EMAIL],
      medName: data[Medication.MEDNAME],
      doseAmt: data[Medication.DOSEAMT],
      timesDaily: data[Medication.TIMESDAILY],
      refillDate: data[Medication.REFILLDATE],
    );
  }

  @override
  String toString() {
    return 'Medication: {medName: ${medName}}';
  }
}
