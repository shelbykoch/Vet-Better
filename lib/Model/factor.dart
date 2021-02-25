class Factor {
  String documentID; //Used for firebase integration
  String name; //name of condition
  String description; //description of condition
  int score; //Score of condition for patient
  bool isSelected; //Whether or not

  Factor(String name, String description, int score) {
    this.name = name;
    this.description = description;
    this.score = score;
    isSelected = false;
  }
}
