class Info {
  String documentId; // used for firebase integration
  String fieldName; // name of text field
  int score; // total of info scores

  Info(String fieldName, int score) {
    this.fieldName = fieldName;
    this.score = score;
  }
}