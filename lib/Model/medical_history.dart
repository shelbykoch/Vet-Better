import 'condition.dart';
import 'history.dart';

class MedicalHistory extends History {
  MedicalHistory() {
    // Instanciate the list
    conditions = new List();
    // Populate list with items
    generateConditionList();
  }
 
  @override
  void generateConditionList() {
    conditions.add(new Condition("Diabetes", 1));
    conditions.add(new Condition("Cancer", 2));
    conditions.add(new Condition("Heart Disease", 2));
    conditions.add(new Condition("High Blood Pressure", 1));
    conditions.add(new Condition("Crohns Disease", 1));
    conditions.add(new Condition("High Cholestoral", 1));
  }

  @override
  int getScore() {
    int score = 0;
    conditions.forEach((c) {
      if (c.isSelected) {
        score += c.score;
      }
    });
    return score;
  }
}
