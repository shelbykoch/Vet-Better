class Condition {
  static const COLLECTION = 'conditions';
  static const DOCUMENTID = 'documentId';
  static const NAME = 'name';
  static const SCORE = 'score';
  //static const ISSELECTED = 'isSelected';

  String documentId; // used for firebase integration
  String name; // name of condition
  int score; // total of patient conditions
  bool isSelected; // whether or not box is checked

  Condition(String name, int score) {
    this.name = name;
    this.score = score;
    isSelected = false;
  }
}
