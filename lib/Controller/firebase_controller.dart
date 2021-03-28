//Firebase connection class
import 'dart:async';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Model/question.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    List<Medication> result;
    if (query != null && query.size != 0) {
      result = new List<Medication>();
      for (var doc in query.docs) {
        result.add(Medication.deserialize(doc.data(), doc.id));
      }
      return result;
    } else {
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

    static Future<void> getNotificationInfo(String email, NotificationSettings info) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(NotificationSettings.COLLECTION)
        .where(NotificationSettings.EMAIL, isEqualTo: email)
        .get();

    if (query != null && query.size != 0) {
      return NotificationSettings.deserialize(query.docs[0].data(), query.docs[0].id);
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
