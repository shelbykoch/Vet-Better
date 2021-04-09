//Firebase connection class
import 'dart:async';
import 'dart:io';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Model/picture.dart';
import 'package:Capstone/Model/question.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/Model/text_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Capstone/Model/notification_settings.dart';

class FirebaseController {
//-------------------------ACCOUNT------------------------//

  static Future<User> login(
      {@required String email, @required String password}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  //-----------------PERSONAL INFORMATION------------------//

  static Future<String> addPersonalInfo(PersonalInfo info) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(PersonalInfo.COLLECTION)
        .add(info.serialize());
    return ref.id;
  }

  static Future<void> updatePersonalInfo(PersonalInfo info) async {
    await FirebaseFirestore.instance
        .collection(PersonalInfo.COLLECTION)
        .doc(info.docID)
        .set(info.serialize());
  }

  static Future<PersonalInfo> getPersonalInfo(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(PersonalInfo.COLLECTION)
        .where(PersonalInfo.EMAIL, isEqualTo: email)
        .get();

    if (query != null && query.size > 0) {
      return PersonalInfo.deserialize(query.docs[0].data(), query.docs[0].id);
    } else {
      return new PersonalInfo.withEmail(email);
    }
  }

  //----------------------FACTOR LIST---------------------------//

  static Future<List<Factor>> getFactorList(
      String email, ListType listType) async {
    print(email);
    print(listType.toString());
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Factor.COLLECTION)
        .where(Factor.EMAIL, isEqualTo: email)
        .where(Factor.LISTTYPE, isEqualTo: listType.index)
        .orderBy(Factor.NAME)
        .get();

    List<Factor> result;
    if (query != null && query.size != 0) {
      result = new List<Factor>();
      for (var doc in query.docs) {
        result.add(Factor.deserialize(doc.data(), doc.id));
      }
      return result;
    } else {
      print("DEFAULT LIST");
      return Factor.getDefaultList(email, listType);
    }
  }

  static Future<void> updateFactor(Factor factor) async {
    await FirebaseFirestore.instance
        .collection(Factor.COLLECTION)
        .doc(factor.docID)
        .set(factor.serialize());
  }

  static Future<String> addFactor(Factor factor) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Factor.COLLECTION)
        .add(factor.serialize());
    return ref.id;
  }

  static Future<void> deleteFactor(Factor factor) async {
    await FirebaseFirestore.instance
        .collection(Factor.COLLECTION)
        .doc(factor.docID)
        .delete();
  }

  //Returns all factors to tabulate score
  static Future<List<Factor>> getAllFactors(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Factor.COLLECTION)
        .where(Factor.EMAIL, isEqualTo: email)
        .orderBy(Factor.NAME)
        .get();

    List<Factor> result = List<Factor>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(Factor.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  //-----------------------CONTACTS-----------------------------//
  static Future<List<Contact>> getContactList(
      String email, ContactType type) async {
    print(email);
    print(type.toString());
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Contact.COLLECTION)
        .where(Contact.EMAIL, isEqualTo: email)
        .where(Contact.TYPE, isEqualTo: type.index)
        .orderBy(Contact.NAME)
        .get();

    List<Contact> result = new List<Contact>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(Contact.deserialize(doc.data(), doc.id));
      }
    } else if ((query == null || query.size == 0) &&
        type == ContactType.Personal) {
      result = await Contact.getDefaultReachOutList(email);
    }
    return result;
  }

  static Future<void> updateContact(Contact contact) async {
    await FirebaseFirestore.instance
        .collection(Contact.COLLECTION)
        .doc(contact.docID)
        .set(contact.serialize());
  }

  static Future<String> addContact(Contact contact) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Contact.COLLECTION)
        .add(contact.serialize());
    return ref.id;
  }

  static Future<void> deleteContact(String docID) async {
    await FirebaseFirestore.instance
        .collection(Contact.COLLECTION)
        .doc(docID)
        .delete();
  }

  //-----------------------ACTIVITIES-----------------------------//
  static Future<List<Activity>> getActivityList(String email) async {
    print(email);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Activity.COLLECTION)
        .where(Activity.EMAIL, isEqualTo: email)
        .orderBy(Activity.NAME)
        .get();

    List<Activity> result = new List<Activity>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(Activity.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateActivity(Activity activity) async {
    await FirebaseFirestore.instance
        .collection(Activity.COLLECTION)
        .doc(activity.docID)
        .set(activity.serialize());
  }

  static Future<String> addActivity(Activity activity) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Activity.COLLECTION)
        .add(activity.serialize());
    return ref.id;
  }

  static Future<void> deleteActivity(Activity activity) async {
    await FirebaseFirestore.instance
        .collection(Activity.COLLECTION)
        .doc(activity.docID)
        .delete();
  }

  //-----------------------LOCATIONS-----------------------------//
  static Future<List<Location>> getLocationList(String email) async {
    print(email);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Location.COLLECTION)
        .where(Location.EMAIL, isEqualTo: email)
        .orderBy(Location.NAME)
        .get();

    List<Location> result = new List<Location>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(Location.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateLocation(Location location) async {
    await FirebaseFirestore.instance
        .collection(Location.COLLECTION)
        .doc(location.docID)
        .set(location.serialize());
  }

  static Future<String> addLocation(Location location) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Location.COLLECTION)
        .add(location.serialize());
    return ref.id;
  }

  static Future<void> deleteLocation(Location location) async {
    await FirebaseFirestore.instance
        .collection(Location.COLLECTION)
        .doc(location.docID)
        .delete();
  }

  //-----------------------SOCIAL-ACTIVITIES-----------------------------//
  static Future<List<SocialActivity>> getSocialActivityList(
      String email) async {
    print(email);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(SocialActivity.COLLECTION)
        .where(SocialActivity.EMAIL, isEqualTo: email)
        .orderBy(SocialActivity.NAME)
        .get();

    List<SocialActivity> result = new List<SocialActivity>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(SocialActivity.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateSocialActivity(
      SocialActivity socialActivity) async {
    await FirebaseFirestore.instance
        .collection(SocialActivity.COLLECTION)
        .doc(socialActivity.docID)
        .set(socialActivity.serialize());
  }

  static Future<String> addSocialActivity(SocialActivity socialActivity) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(SocialActivity.COLLECTION)
        .add(socialActivity.serialize());
    return ref.id;
  }

  static Future<void> deleteSocialActivity(
      SocialActivity socialActivity) async {
    await FirebaseFirestore.instance
        .collection(SocialActivity.COLLECTION)
        .doc(socialActivity.docID)
        .delete();
  }

  //-----------------------FEEL GOOD VAULT TEXT CONTENT-----------------------------//
  static Future<List<TextContent>> getTextContentList(String email) async {
    print(email);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(TextContent.COLLECTION)
        .where(TextContent.EMAIL, isEqualTo: email)
        .orderBy(TextContent.TITLE)
        .get();

    List<TextContent> result = new List<TextContent>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(TextContent.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updateTextContent(TextContent textContent) async {
    await FirebaseFirestore.instance
        .collection(TextContent.COLLECTION)
        .doc(textContent.docID)
        .set(textContent.serialize());
  }

  static Future<String> addTextContent(TextContent textContent) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(TextContent.COLLECTION)
        .add(textContent.serialize());
    return ref.id;
  }

  static Future<void> deleteTextContent(TextContent textContent) async {
    await FirebaseFirestore.instance
        .collection(TextContent.COLLECTION)
        .doc(textContent.docID)
        .delete();
  }

  //-----------------------FEEL GOOD VAULT PICTURES-----------------------------//
  static Future<List<Picture>> getPictures(String email) async {
    print(email);
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(TextContent.COLLECTION)
        .where(TextContent.EMAIL, isEqualTo: email)
        .orderBy(TextContent.TITLE)
        .get();

    List<Picture> result = new List<Picture>();
    if (query != null && query.size != 0) {
      for (var doc in query.docs) {
        result.add(Picture.deserialize(doc.data(), doc.id));
      }
    }
    return result;
  }

  static Future<void> updatePicture(Picture picture) async {
    await FirebaseFirestore.instance
        .collection(Picture.COLLECTION)
        .doc(picture.docId)
        .set(picture.serialize());
  }

  static Future<String> addPicture(Picture picture) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Picture.COLLECTION)
        .add(picture.serialize());
    return ref.id;
  }

  static Future<void> deletePicture(Picture picture) async {
    await FirebaseFirestore.instance
        .collection(Picture.COLLECTION)
        .doc(picture.docId)
        .delete();
  }

  static Future<Map<String, String>> uploadStorage({
    @required File image,
    String filePath,
    @required String uid,
    @required Function listener,
  }) async {
    filePath ??= '${Picture.IMAGE_FOLDER}/$uid/${DateTime.now()}';

    UploadTask task =
        FirebaseStorage.instance.ref().child(filePath).putFile(image);
    task.snapshotEvents.listen((event) {
      double percentage =
          (event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
              100;
      listener(percentage);
    });
    var download = await task;
    String url = await download.ref.getDownloadURL();
    return {'url': url, 'path': filePath};
  }

  //-------------------APPOINTMENTS-----------------------------//

  static Future<List<Appointment>> getAppointmentList(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Appointment.COLLECTION)
        .where(Appointment.EMAIL, isEqualTo: email)
        .orderBy(Appointment.DATE_TIME, descending: true)
        .get();

    List<Appointment> result;
    if (query != null && query.size != 0) {
      result = new List<Appointment>();
      for (var doc in query.docs) {
        result.add(Appointment.deserialize(doc.data(), doc.id));
      }
      return result;
    } else {
      //returns empty list if user has not appointments in the database
      return new List<Appointment>();
    }
  }

  static Future<void> updateAppointment(Appointment appointment) async {
    await FirebaseFirestore.instance
        .collection(Appointment.COLLECTION)
        .doc(appointment.docID)
        .set(appointment.serialize());
  }

  static Future<String> addAppointment(Appointment appointment) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Appointment.COLLECTION)
        .add(appointment.serialize());
    return ref.id;
  }

  static Future<void> deleteAppointment(String docID) async {
    await FirebaseFirestore.instance
        .collection(Appointment.COLLECTION)
        .doc(docID)
        .delete();
  }

//-----------------MEDICATION INFORMATION------------------//

  static Future<String> addMedication(Medication info) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Medication.COLLECTION)
        .add(info.serialize());
    return ref.id;
  }

  static Future<void> updateMedicationInfo(Medication info) async {
    await FirebaseFirestore.instance
        .collection(Medication.COLLECTION)
        .doc(info.docId)
        .set(info.serialize());
  }

  static Future<void> getMedicationInfo(String email, Medication info) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Medication.COLLECTION)
        .where(Medication.EMAIL, isEqualTo: email)
        .get();

    if (query != null && query.size != 0) {
      return Medication.deserialize(query.docs[0].data(), query.docs[0].id);
    } else {
      return new Medication.withEmail(email);
    }
  }

  static Future<List<Medication>> getMedicationList(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Medication.COLLECTION)
        .where(Medication.EMAIL, isEqualTo: email)
        .get();
    print('got query');
    List<Medication> result;
    if (query != null && query.size != 0) {
      print("${query.size}");
      result = new List<Medication>();
      for (var doc in query.docs) {
        print('in for loop');
        result.add(Medication.deserialize(doc.data(), doc.id));
      }
      print('got result');
      return result;
    } else {
      print('didn' 't get result');
      return null;
    }
  }

  static Future<void> deleteMedication(String docID) async {
    await FirebaseFirestore.instance
        .collection(Medication.COLLECTION)
        .doc(docID)
        .delete();
  }

//-----------------DAILY QUESTIONS------------------//

  static Future<String> addQuestionInfo(Question info) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Question.COLLECTION)
        .add(info.serialize());
    return ref.id;
  }

  static Future<void> updateQuestionInfo(Question info) async {
    await FirebaseFirestore.instance
        .collection(Question.COLLECTION)
        .doc(info.docId)
        .set(info.serialize());
  }

  static Future<List<Question>> getQuestionList(String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(Question.COLLECTION)
        .where(Question.EMAIL, isEqualTo: email)
        .orderBy(Question.QUESTION_NUMBER)
        .get();

    List<Question> result;
    if (query != null && query.size != 0) {
      result = new List<Question>();
      for (var doc in query.docs) {
        result.add(Question.deserialize(doc.data(), doc.id));
      }
      return result;
    } else {
      return null;
    }
  }

  static Future<void> deleteQuestion(String docID) async {
    await FirebaseFirestore.instance
        .collection(Question.COLLECTION)
        .doc(docID)
        .delete();
  }

//-----------------NOTIFICATIONS------------------//

  static Future<String> addNotificationSetting(
      NotificationSettings info) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(NotificationSettings.COLLECTION)
        .add(info.serialize());
    return ref.id;
  }

  static Future<void> updateNotificationSetting(
      NotificationSettings info) async {
    await FirebaseFirestore.instance
        .collection(NotificationSettings.COLLECTION)
        .doc(info.docId)
        .set(info.serialize());
  }

  static Future<void> getNotificationInfo(
      String email, NotificationSettings info) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(NotificationSettings.COLLECTION)
        .where(NotificationSettings.EMAIL, isEqualTo: email)
        .get();

    if (query != null && query.size != 0) {
      return NotificationSettings.deserialize(
          query.docs[0].data(), query.docs[0].id);
    } else {
      return new NotificationSettings.withEmail(email);
    }
  }

  static Future<List<NotificationSettings>> getNotificationSettings(
      String email) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(NotificationSettings.COLLECTION)
        .where(NotificationSettings.EMAIL, isEqualTo: email)
        .get();

    List<NotificationSettings> result;
    if (query != null && query.size != 0) {
      result = new List<NotificationSettings>();
      for (var doc in query.docs) {
        result.add(NotificationSettings.deserialize(doc.data(), doc.id));
      }
      return result;
    } else {
      return null;
    }
  }
}
