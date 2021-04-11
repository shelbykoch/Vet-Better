import '../Controller/firebase_controller.dart';
import 'activity.dart';
import 'contact.dart';
import 'location.dart';

class SocialActivity {
  String docID;
  String email;
  String name;
  Contact contact;
  Activity activity;
  Location location;

  SocialActivity({
    this.docID,
    this.email,
    this.name,
    this.contact,
    this.activity,
    this.location,
  });

  SocialActivity.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      NAME: name,
      CONTACT: contact.docID,
      ACTIVITY: activity.docID,
      LOCATION: location.docID,
    };
  }

  static SocialActivity deserialize(Map<String, dynamic> data, String docId) {
    return SocialActivity(
      docID: docId,
      email: data[SocialActivity.EMAIL],
      name: data[SocialActivity.NAME],
      contact: null,
      //await FirebaseController.getContact(data[SocialActivity.CONTACT]),
      activity: null,
      //await FirebaseController.getActivity(data[SocialActivity.ACTIVITY]),
      location: null,
      //await FirebaseController.getLocation(data[SocialActivity.LOCATION]),
    );
  }

  static const COLLECTION = 'socialActivity';
  static const EMAIL = 'email';
  static const NAME = 'name';
  static const CONTACT = 'contact';
  static const ACTIVITY = 'activity';
  static const LOCATION = 'location';
}
