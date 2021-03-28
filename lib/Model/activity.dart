class Activity {
  String docID;
  String email;
  String name;
  String description;

  Activity({
    this.docID,
    this.email,
    this.name,
    this.description,
  });

  Activity.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NAME: name,
      DESCRIPTION: description,
    };
  }

  static Activity deserialize(Map<String, dynamic> data, String docId) {
    return Activity(
      docID: docId,
      email: data[Activity.EMAIL],
      name: data[Activity.NAME],
      description: data[Activity.DESCRIPTION],
    );
  }

  static const COLLECTION = 'activity';
  static const EMAIL = 'email';
  static const NAME = 'name';
  static const DESCRIPTION = 'description';
}
