enum MedicalHistory {
  Diabetes,
  Cancer,
  HeartDisease,
  HighBloodPressure,
  CrohnsDisease,
  HighCholestoral,
}
enum PsychiatricHistory {
  Anxiety,
  Depression,
  SuicideAttempt,
  ADDADHD,
  Bipolar,
  Schizophrenia,
  EatingDisorder,
}

class History {
  Map medicalHistory = {
    MedicalHistory.Diabetes: true,
    MedicalHistory.Cancer: true,
    MedicalHistory.HeartDisease: true,
    MedicalHistory.HighBloodPressure: true,
    MedicalHistory.CrohnsDisease: true,
    MedicalHistory.HighCholestoral: true,
  };
  Map psychiatricHistory = {
    PsychiatricHistory.Anxiety: false,
    PsychiatricHistory.Depression: false,
    PsychiatricHistory.SuicideAttempt: false,
    PsychiatricHistory.ADDADHD: false,
    PsychiatricHistory.Bipolar: false,
    PsychiatricHistory.Schizophrenia: false,
    PsychiatricHistory.EatingDisorder: false,
  };
  History() {
    this.medicalHistory = Map.of(medicalHistory);
    this.psychiatricHistory = Map.of(psychiatricHistory);
  }
  History.clone(History h) {
    this.medicalHistory = Map.from(h.medicalHistory);
    this.psychiatricHistory = Map.from(h.psychiatricHistory);
  }
}
