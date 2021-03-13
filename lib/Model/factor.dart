//This enum is used to determine which screen the factor will be diplayed on
import 'package:Capstone/Controller/firebase_controller.dart';

enum ListType {
  MedicalHistory,
  PsychHistory,
  RiskFactors,
  MitigationFactors,
  CopingStrategies,
  WarningSigns
}

class Factor {
  String docID; //Firebase DocID
  String email; //Creator of the factor
  String name; //name of condition
  String description; //description of condition
  int score; //Score of condition for patient
  bool isSelected; //Whether or not
  ListType listType;

  Factor({
    this.docID,
    this.email,
    this.name,
    this.score,
    this.description,
    this.listType,
    this.isSelected,
  });

  //Standard constructor used when returning default lists
  Factor.standard(String email, String name, int score, ListType listType,
      [String description = ""]) {
    this.email = email;
    this.name = name;
    this.score = score;
    this.description = description;
    this.listType = listType;
    this.isSelected = false;
    this.description = description;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NAME: name,
      SCORE: score,
      DESCRIPTION: description,
      LISTTYPE: listType.index,
      ISSELECTED: isSelected,
    };
  }

  static Factor deserialize(Map<String, dynamic> data, String docId) {
    return Factor(
      docID: docId,
      email: data[Factor.EMAIL],
      name: data[Factor.NAME],
      description: data[Factor.DESCRIPTION],
      score: data[Factor.SCORE],
      listType: ListType.values[data[Factor.LISTTYPE]], //We store the enum as
      //as int so we need to select it from the values
      isSelected: data[Factor.ISSELECTED],
    );
  }

  static const EMAIL = 'email';
  static const NAME = 'name';
  static const SCORE = 'score';
  static const DESCRIPTION = 'description';
  static const LISTTYPE = 'listType';
  static const ISSELECTED = 'isselected';
  static const COLLECTION = 'factor';

  //------------------------LIST TYPES-----------------------------------//

  //If a firebase DB call returns no documents, then the user has not
  //created a list yet, so return a default to be displayed and saved
  //into firebase for the next session
  static List<Factor> getDefaultList(String email, ListType listType) {
    List<Factor> result;
    switch (listType) {
      case ListType.MedicalHistory:
        result = _getMedicalHistory(email);
        break;
      case ListType.PsychHistory:
        result = _getPsychiatricHistory(email);
        break;
      case ListType.RiskFactors:
        result = _getRiskFactors(email);
        break;
      case ListType.MitigationFactors:
        result = _getMitigationFactors(email);
        break;
      case ListType.CopingStrategies:
        result = _getCopingStrategies(email);
        break;
      case ListType.WarningSigns:
        result = _getWarningSigns(email);
        break;
      default:
        result = _getMedicalHistory(email);
    }
    //Since this is the first instance of the list being referrenced we must
    //store all default values for later since the screen will only save them
    //on isSelected change
    result.forEach((f) async {
      f.docID = await FirebaseController.addFactor(f);
    });
    return result;
  }

  //!!!!! PLEASE KEEP THESE LISTS ALPHABATIZED!!!!!!!!!!!!!!!/////////

  static List<Factor> _getMedicalHistory(String email) {
    List<Factor> factors = new List<Factor>();
    ListType listType = ListType.MedicalHistory;
    factors.add(new Factor.standard(email, "Cancer", 2, listType));
    factors.add(new Factor.standard(email, "Crohns Disease", 1, listType));
    factors.add(new Factor.standard(email, "Diabetes", 1, listType));
    factors.add(new Factor.standard(email, "Heart Disease", 2, listType));
    factors.add(new Factor.standard(email, "High Blood Pressure", 1, listType));
    factors.add(new Factor.standard(email, "High Cholestoral", 1, listType));
    return factors;
  }

  static List<Factor> _getPsychiatricHistory(String email) {
    List<Factor> factors = new List<Factor>();
    ListType listType = ListType.PsychHistory;
    factors.add(new Factor.standard(email, "Anxiety", 1, listType));
    factors.add(new Factor.standard(email, "Bipolar Disorder", 2, listType));
    factors.add(new Factor.standard(email, "Depression", 2, listType));
    factors.add(new Factor.standard(email, "Eating Disorder", 1, listType));
    factors.add(new Factor.standard(
        email, "Post-Traumatic Stress Disorder", 2, listType));
    factors.add(new Factor.standard(email, "Schizophrenia", 2, listType));
    return factors;
  }

  static List<Factor> _getMitigationFactors(String email) {
    List<Factor> factors = new List<Factor>();
    ListType listType = ListType.MitigationFactors;
    factors.add(new Factor.standard(email, "Closeness with family", 2, listType,
        "Are you close with your family? Do you freqeuntly communicate?"));
    factors.add(new Factor.standard(email, "Future Orientation", 1, listType,
        "Do you have goals set for yourself?"));
    factors.add(new Factor.standard(email, "Perceived Support", 2, listType,
        "Do you feel like you have people that support you?"));
    factors.add(new Factor.standard(email, "Persitence", 1, listType,
        "Do you belive you will get through your problems?"));
    factors.add(new Factor.standard(email, "Role in the community", 2, listType,
        "Do you feel as if you are involved in your community and play a role?"));
    factors.add(new Factor.standard(email, "Sense of belonging", 2, listType,
        "Do you feel like you fit in/belong in your community?"));
    factors.add(new Factor.standard(email, "Sense of resiliance", 1, listType,
        "Do you feel like you recover quickly from difficulties?"));
    return factors;
  }

  static List<Factor> _getRiskFactors(String email) {
    List<Factor> factors = new List<Factor>();
    ListType listType = ListType.RiskFactors;
    factors.add(new Factor.standard(email, "Aggressive Tendencies", 1, listType,
        "Do you often feel agressive toward others or yourself?"));
    factors.add(new Factor.standard(email, "Criminal Problems", 1, listType,
        "Are you facing unresolved criminal charges?"));
    factors.add(new Factor.standard(email, "Impulsive Tendencies", 1, listType,
        "Do you often make impulsive or irresponsible decisions?"));
    factors.add(new Factor.standard(
        email, "Owning a firearm", 2, listType, "Do you own a firearm?"));
    factors.add(new Factor.standard(email, "Previous Self Harm", 2, listType,
        "Have you previously attempted to harm yourself?"));
    factors.add(new Factor.standard(email, "Previous Suicide Attempt", 2,
        listType, "Have you previously attempted suicide?"));
    factors.add(new Factor.standard(email, "Social Isolation", 2, listType,
        "Do you feel socially isolated from others?"));

    return factors;
  }

  static List<Factor> _getCopingStrategies(String email) {
    List<Factor> factors = new List<Factor>();
    ListType listType = ListType.CopingStrategies;
    return factors;
  }

  static List<Factor> _getWarningSigns(String email) {
    List<Factor> factors = new List<Factor>();
    ListType listType = ListType.WarningSigns;
    return factors;
  }
}
