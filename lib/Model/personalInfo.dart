import 'profile.dart';
import 'info.dart';

class PersonalInfo extends Profile {
  int riskScore;

  PersonalInfo() {
    info = new List();
    generateInfoList();
    this.riskScore = riskScore;
  }

  @override
  void generateInfoList() {
    info.add(new Info("Name", 0));
    info.add(new Info("Age", 1));
    info.add(new Info("Gender/Sex", 2));
    info.add(new Info("Religious Affiliation", 3));
    info.add(new Info("Sexual Orientation", 4));
    info.add(new Info("Military History", 5));
  }

  @override
  int getScore() {
    int score = 0;
    info.forEach((c) {
        score += c.score;
    });
    return score;
  }
}
