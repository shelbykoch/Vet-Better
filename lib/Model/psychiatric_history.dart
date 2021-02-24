import 'condition.dart';
import 'history.dart';

class PsychiatricHistory extends History {
  PsychiatricHistory() {
    // Instanciate the List
    conditions = new List();
    // Populate list with items
    generateConditionList();
  }

  @override
  void generateConditionList() {
    conditions.add(new Condition("Anxiety", 1));
    conditions.add(new Condition("Depression", 2));
    conditions.add(new Condition("Eating Disorder", 1));
    conditions.add(new Condition("Bipolar Disorder", 2));
    conditions.add(new Condition("Post-Traumatic Stress Disorder", 2));
    conditions.add(new Condition("Schizophrenia", 2));

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
