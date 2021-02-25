import 'factor.dart';
import 'factors.dart';

//This class will be generated for the user and applied to their profile
//object when they sign up. Since the condition constructor sets them all to
//false when you create the buttons they will automatically be unchecked
class MitigationFactors extends Factors {
  MitigationFactors() {
    //Instantiate list
    factors = new List();
    //Populate list with items
    generateConditionList();
  }

  @override
  void generateConditionList() {
    factors.add(new Factor("Sense of belonging",
        "Do you feel like you fit in/belong in your community?", 2));
    factors.add(new Factor("Closeness with family",
        "Are you close with your family? Do you freqeuntly communicate?", 2));
    factors.add(new Factor("Perceived Support",
        "Do you feel like you have people that support you?", 2));
    factors.add(new Factor(
        "Role in the community",
        "Do you feel as if you are involved in your community and play a role?",
        2));
    factors.add(new Factor("Sense of resiliance",
        "Do you feel like you recover quickly from difficulties?", 1));
    factors.add(new Factor(
        "Persitence", "Do you belive you will get through your problems?", 1));
    factors.add(new Factor(
        "Future Orientation", "Do you have goals set for yourself?", 1));
  }

  //Loop through every condition and add it to the total
  //if it is selected then return the score
  @override
  int getScore() {
    int score = 0;
    factors.forEach((c) {
      if (c.isSelected) {
        score += c.score;
      }
    });
    return score;
  }
}
