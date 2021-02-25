import 'factor.dart';
import 'factors.dart';

//This class will be generated for the user and applied to their profile
//object when they sign up. Since the condition constructor sets them all to
//false when you create the buttons they will automatically be unchecked
class RiskFactors extends Factors {
  RiskFactors() {
    //Instantiate list
    factors = new List();
    //Populate list with items
    generateConditionList();
  }

  @override
  void generateConditionList() {
    factors.add(new Factor("Previous Suicide Attempt",
        "Have you previously attempted suicide?", 2));
    factors.add(new Factor("Previous Self Harm",
        "Have you previously attempted to harm yourself?", 2));
    factors.add(new Factor("Owning a firearm", "Do you own a firearm?", 2));
    factors.add(new Factor("Mental Illness", "Ex: Depression, Anxiety", 2));
    factors.add(new Factor(
        "Social Isolation", "Do you feel socially isolated from others?", 2));
    factors.add(new Factor(
        "Criminal Problems", "Are you facing unresolved criminal charges?", 1));
    factors.add(new Factor("Impulsive Tendencies",
        "Do you often make impulsive or irresponsible decisions?", 1));
    factors.add(new Factor("Aggressive Tendencies",
        "Do you often feel agressive toward others or yourself?", 1));
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
