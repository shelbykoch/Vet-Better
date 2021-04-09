class PersonalInfoOptions {
  static final PersonalInfoOptions _instance = PersonalInfoOptions._internal();

  factory PersonalInfoOptions() {
    return _instance;
  }

  PersonalInfoOptions._internal();

  static Map<SexualPreference, String> sexualPreferenceMap = const {
    SexualPreference.Heterosexual: 'Heterosexual',
    SexualPreference.Gay_Lesbian: "Gay/Lesbian",
    SexualPreference.Bisexual: "Bisexual",
    SexualPreference.Pansexual: "Pansexual",
    SexualPreference.Asexual: "Asexual",
    SexualPreference.Other: "Other",
  };

  static Map<ReligiousAffiliation, String> religiousAffiliationMap = const {
    ReligiousAffiliation.Christianity: 'Christianity',
    ReligiousAffiliation.Islam: 'Islam',
    ReligiousAffiliation.Judaism: 'Judaism',
    ReligiousAffiliation.Hinduism: 'Hinduism',
    ReligiousAffiliation.Buddism: 'Buddism',
    ReligiousAffiliation.Secular_Nonreligious_Agnostic_Athiest:
        'Secular/Nonreligious/Agnostic/Athiest',
    ReligiousAffiliation.Other: 'Other',
  };

  static Map<MilitaryHistory, String> militaryHistoryMap = const {
    MilitaryHistory.One_Five: '1-5 years',
    MilitaryHistory.Six_Ten: '6-10 years',
    MilitaryHistory.Ten_Plus: '10+ years',
  };

  static Map<Gender, String> genderMap = const {
    Gender.Male: 'Male',
    Gender.Female: 'Female',
    Gender.Transgender: 'Transgender',
    Gender.Gender_Neutral: 'Gender Neutral',
    Gender.Non_Binary: 'Non Binary',
    Gender.Pangender: 'Pangender',
    Gender.Other: 'Other',
  };
}

enum SexualPreference {
  Heterosexual,
  Gay_Lesbian,
  Bisexual,
  Pansexual,
  Asexual,
  Other
}

enum ReligiousAffiliation {
  Christianity,
  Islam,
  Judaism,
  Hinduism,
  Buddism,
  Secular_Nonreligious_Agnostic_Athiest,
  Other,
}

enum MilitaryHistory {
  One_Five,
  Six_Ten,
  Ten_Plus,
}

enum Gender {
  Male,
  Female,
  Transgender,
  Gender_Neutral,
  Non_Binary,
  Pangender,
  Other,
}
