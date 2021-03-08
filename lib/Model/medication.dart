class Medication {
  String medName;
  int medCount;
  int doseAmt; // in mg
  bool isScheduled; // scheduled vs as needed
  int timesDaily; // how many doses per day
  List<dynamic> medications;
  DateTime timeOfDay;

  Medication({
    this.medName,
    medCount = 0,
    this.doseAmt,
    isScheduled,
    this.timesDaily,
  }) {
    this.medications ??= [];
  }

  void generateMedList() {
    medications.add(new Medication());
  }
}
