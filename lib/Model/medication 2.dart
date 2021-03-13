import 'package:flutter/cupertino.dart';

class Medication {
  static const COLLECTION = 'medicationInfo';
  static const EMAIL = 'email';
  static const MEDNAME = 'medName';
  static const DOSEAMT = 'doseAmt';
  static const TIMESDAILY = 'timesDaily';
  static const REFILLDATE = 'refillDate';
  static const REFILLSLEFT = 'refillsLeft';

  // Field names and values
  String docId;
  String email;
  String medName;
  String doseAmt; // in mg
  String timesDaily; // how many doses per day
  DateTime refillDate;
  String refillsLeft;

  Medication(
      {this.docId,
      this.email,
      this.medName,
      this.doseAmt,
      this.timesDaily,
      this.refillDate,
      this.refillsLeft,
      });

  Medication.withEmail(@required String email) {
    this.email = email;
  }

  Map<dynamic, dynamic> serialize() {
    return <dynamic, dynamic>{
      EMAIL: this.email,
      MEDNAME: medName,
      DOSEAMT: doseAmt,
      TIMESDAILY: timesDaily,
      REFILLDATE: refillDate,
      REFILLSLEFT: refillsLeft,
    };
  }

  static Medication deserialize(Map<dynamic, dynamic> data, String docId) {
    return Medication(
      docId: docId,
      email: data[Medication.EMAIL],
      medName: data[Medication.MEDNAME],
      doseAmt: data[Medication.DOSEAMT],
      timesDaily: data[Medication.TIMESDAILY],
      refillDate: data[Medication.REFILLDATE],
      refillsLeft: data[Medication.REFILLSLEFT],
    );
  }

  @override
  String toString() {
    return 'Medication: {medName: ${medName}}';
  }
}
