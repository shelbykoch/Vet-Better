import 'package:Capstone/Controller/firebase_controller.dart';

enum ContactType {
  Emergency, //Emergency services
  Personal, //People to reach out to and demographic based resources
  Social //Social activities
}

class Contact {
  String docID;
  String email;
  String name;
  String address;
  String phoneNumber;
  String notes;
  ContactType type; //Used to split contacts into their appropriate screens

  Contact(
      {this.docID,
      this.email,
      this.name,
      this.address,
      this.phoneNumber,
      this.notes,
      this.type});

  Contact.withEmail(String email, ContactType type) {
    this.email = email;
    this.type = type;
  }

  static List<Contact> getDefaultReachOutList(String email) {
    List<Contact> defaultList = new List<Contact>();
    //National suicide prevention lifeline
    defaultList.add(Contact(
        email: email,
        name: "National Suicide Prevention Lifeline",
        address: "Los Angeles, CA",
        phoneNumber: "800-273-8255",
        type: ContactType.Personal));
    defaultList.add(Contact(
        email: email,
        name: "Veteran Crisis Line",
        address: "N/A",
        phoneNumber: "1-800-273-8255",
        type: ContactType.Personal,
        notes: "Press 1 or text 838255"));
    defaultList.add(Contact(
        email: email,
        name: "LGBTQ Crisis Intervention List",
        address: "N/A",
        phoneNumber: "1-866-488-7386",
        type: ContactType.Personal,
        notes: "Visit thetrevorproject.org for more information"));
    defaultList.add(Contact(
        email: email,
        name: "Substance Abuse and Mental Health Services Administration",
        address: "N/A",
        phoneNumber: "1-800-622-4357",
        type: ContactType.Personal,
        notes: "Visit samhsa.gov for more information"));

    defaultList.forEach((c) async {
      c.docID = await FirebaseController.addContact(c);
    });
    return defaultList;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NAME: name,
      ADDRESS: address,
      PHONENUMBER: phoneNumber,
      NOTES: notes,
      TYPE: type.index, //Firebase requires primitive types, so store as int
    };
  }

  static Contact deserialize(Map<String, dynamic> data, String docId) {
    return Contact(
        docID: docId,
        email: data[Contact.EMAIL],
        name: data[Contact.NAME],
        address: data[Contact.ADDRESS],
        phoneNumber: data[Contact.PHONENUMBER],
        notes: data[Contact.NOTES],
        type: ContactType.values[data[Contact.TYPE]] //Convert from int to enum
        );
  }

  static const COLLECTION = 'contact';
  static const EMAIL = 'email';
  static const NAME = 'name';
  static const ADDRESS = 'address';
  static const PHONENUMBER = 'phoneNumber';
  static const NOTES = 'notes';
  static const TYPE = 'type';
}
