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
    MedicalHistory.Diabetes: false,
    MedicalHistory.Cancer: false,
    MedicalHistory.HeartDisease: false,
    MedicalHistory.HighBloodPressure: false,
    MedicalHistory.CrohnsDisease: false,
    MedicalHistory.HighCholestoral: false,
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
  History();
  History.clone(History h) {
    this.medicalHistory = Map.from(h.medicalHistory);
    this.psychiatricHistory = Map.from(h.psychiatricHistory);
  }
}
