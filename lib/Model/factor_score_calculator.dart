import 'package:Capstone/Controller/firebase_controller.dart';
import 'factor.dart';

class FactorScoreCalculator {
  static final FactorScoreCalculator _instance =
      FactorScoreCalculator._internal();

  factory FactorScoreCalculator() {
    return _instance;
  }

  FactorScoreCalculator._internal();

  //Returns a map containing an enum for the factor list it applies to
  //and the score for that section
  Future<Map<ListType, int>> getScoreMap(String email) async {
    Map<ListType, int> _scoreMap = Map<ListType, int>();

    List<Factor> factorList = await FirebaseController.getAllFactors(email);

    factorList.forEach((factor) {
      if (!_scoreMap.keys.contains(factor.listType))
        _scoreMap[factor.listType] = 0;
      if (factor.isSelected) {
        _scoreMap[factor.listType] += factor.score;
      }
    });
    return _scoreMap;
  }

  Future<int> getTotalScore(String email) async {
    Map<ListType, int> _scoreMap = await getScoreMap(email);
    int total = 0;
    _scoreMap.forEach((key, value) {
      total += value;
    });
    return total;
  }
}
