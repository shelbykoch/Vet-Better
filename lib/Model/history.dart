//Since both medical and psychiatric history will be similar data models
//it is best practice to declare a super or base class.
//We use the keyword abstract because we will never user the history object alone.
//We only use it in the context of medical or psychiatric history. So this
//abstract class will create a framework for the two sub classes and ensure
//that we don't have to make changes to both the medical and psychiatric history
//classes. We can just make them here and they will apply

abstract class History {
  String documentId;
  List conditions;
  void generateConditionList();
  int getScore();
}

