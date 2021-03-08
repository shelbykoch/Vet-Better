class Medication {
  static const COLLECTION = 'medicationInfo';
  static const EMAIL = 'email';
  static const MEDNAME = 'medName';
  static const MEDCOUNT = 'medCount';
  static const DOSEAMT = 'doseAmt';
  static const ISSCHEDULED = 'isScheduled';
  static const TIMESDAILY = 'timesDaily';
  static const MEDICATIONS = 'medications';
  static const TIMEOFDAY = 'timeOfDay';

  // Field names and values
  String docId;
  String email;
  String medName;
  int medCount;
  int doseAmt; // in mg
  bool isScheduled; // scheduled vs as needed
  int timesDaily; // how many doses per day
  List<dynamic> medications;
  DateTime timeOfDay;

  Medication({
    this.docId,
    this.email,
    this.medName,
    medCount = 0,
    this.doseAmt,
    isScheduled,
    this.timesDaily,
    this.medications,
    this.timeOfDay,
  }) {
    this.medications ??= [];
  }

  Medication.withEmail(String email) {
    this.email = email;
  }

  void generateMedList() {
    medications.add(new Medication());
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      MEDNAME: medName,
      MEDCOUNT: medCount,
      DOSEAMT: doseAmt,
      ISSCHEDULED: isScheduled,
      TIMESDAILY: timesDaily,
      MEDICATIONS: medications,
      TIMEOFDAY: timeOfDay,
    };
  }

  static Medication deserialize(Map<String, dynamic> data, String docId) {
    return Medication(
        docId: docId,
        email: data[Medication.EMAIL],
        medName: data[Medication.MEDNAME],
        medCount: data[Medication.MEDCOUNT],
        doseAmt: data[Medication.DOSEAMT],
        isScheduled: data[Medication.ISSCHEDULED],
        timesDaily: data[Medication.TIMESDAILY],
        medications: data[Medication.MEDICATIONS],
        timeOfDay: data[Medication.TIMEOFDAY]);
  }
}
