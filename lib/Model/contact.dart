import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/resource_list_builder.dart';

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

  static Future<List<Contact>> getDefaultReachOutList(String email) {
    ResourceListBuilder rbuilder = new ResourceListBuilder();
    return rbuilder.createResourceList(email);
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
