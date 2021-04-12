import 'package:Capstone/Model/notification_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  static const COLLECTION = 'medicationInfo';
  static const EMAIL = 'email';
  static const MEDNAME = 'medName';
  static const DOSEAMT = 'doseAmt';
  static const TIMESDAILY = 'timesDaily';
  static const RENEWALDATE = 'renewalDate';
  static const REFILLDATE = 'refillDate';
  static const REFILLSLEFT = 'refillsLeft';

  // Field names and values
  String docId;
  String email;
  String medName;
  String doseAmt; // in mg
  int timesDaily; // how many doses per day
  DateTime renewalDate;
  DateTime refillDate;
  int refillsLeft;

  Medication(
      {this.docId,
      this.email,
      this.medName,
      this.doseAmt,
      this.timesDaily,
      this.renewalDate,
      this.refillDate,
      this.refillsLeft});

  Medication.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      MEDNAME: medName,
      DOSEAMT: doseAmt,
      TIMESDAILY: timesDaily,
      RENEWALDATE: renewalDate,
      REFILLDATE: refillDate,
      REFILLSLEFT: refillsLeft,
    };
  }

  static Medication deserialize(Map<String, dynamic> data, String docId) {
    DateTime date;
    if (data[Medication.REFILLDATE] != null) {
      Timestamp ts = data[Medication.REFILLDATE];
      date = ts.toDate();
    } else
      date = null;
    return Medication(
      docId: docId,
      email: data[Medication.EMAIL],
      medName: data[Medication.MEDNAME],
      doseAmt: data[Medication.DOSEAMT],
      timesDaily: data[Medication.TIMESDAILY],
      refillsLeft: data[Medication.REFILLSLEFT],
      renewalDate: date,
      refillDate: date,
    );
  }

  // String getTime() {
  //   return DateFormat.jm().format(this.renewalDate).toString();
  // }

  @override
  String toString() {
    return 'Medication: {medName: ${medName}}';
  }

  DateTime renewalTime(refillsLeft) {
    var now = DateTime.now();
    int numberOfDays = 30 * refillsLeft - 7;
    DateTime renewalDate = now.add(Duration(days: numberOfDays));
    print("renewalDate: ${renewalDate}");
    return renewalDate;
  }

  DateTime refillTime(refillDate) {
    DateTime refillReminderDate = refillDate.subtract(Duration(days: 3));
    return refillReminderDate;
  }
}
