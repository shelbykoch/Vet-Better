class Location {
  String docID;
  String email;
  String name;
  String address;

  Location({
    this.docID,
    this.email,
    this.name,
    this.address,
  });

  Location.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NAME: name,
      ADDRESS: address,
    };
  }

  static Location deserialize(Map<String, dynamic> data, String docId) {
    return Location(
      docID: docId,
      email: data[Location.EMAIL],
      name: data[Location.NAME],
      address: data[Location.ADDRESS],
    );
  }

  static const COLLECTION = 'location';
  static const EMAIL = 'email';
  static const NAME = 'name';
  static const ADDRESS = 'address';
}
