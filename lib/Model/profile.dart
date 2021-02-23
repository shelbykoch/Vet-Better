class Profile {
  static const COLLECTION = 'userProfile';
  static const NAME = 'name';
  static const AGE = 'age';
  static const GENDER = 'gender';
  static const RELIGION = 'religion';
  static const SEXUALORIENATION = 'sexualOrientation';
  static const MILITARYHISTORY = 'militaryHistory';

  String name;
  String age;
  String gender;
  String religion;
  String sexualOrientation;
  String militaryHistory;

  Profile({
    this.name,
    this.age,
    this.gender,
    this.religion,
    this.sexualOrientation,
    this.militaryHistory,
  });

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME: name,
      AGE: age,
      GENDER: gender,
      RELIGION: religion,
      SEXUALORIENATION: sexualOrientation,
      MILITARYHISTORY: militaryHistory,
    };
  }

  static Profile deserialize(Map<String, dynamic> data, String name) {
    return Profile(
      name: name,
      age: data[Profile.AGE],
      gender: data[Profile.GENDER],
      religion: data[Profile.RELIGION],
      sexualOrientation: data[Profile.SEXUALORIENATION],
      militaryHistory: data[Profile.MILITARYHISTORY],
    );
  }

  @override
  String toString() {
    return '$name $age $gender $religion $sexualOrientation $militaryHistory';
  }
}
