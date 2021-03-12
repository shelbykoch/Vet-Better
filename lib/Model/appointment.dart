import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Appointment {
  String docID; //Firebase DocID
  String email; //user who created appointment
  String title; //appointment title
  String location; //appointment location
  DateTime dateTime; //Appointment dateTime

  Appointment({
    this.docID,
    this.email,
    this.title,
    this.location,
    this.dateTime,
  });

  Appointment.withEmail(String email) {
    this.email = email;
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      EMAIL: email,
      TITLE: title,
      LOCATION: location,
      DATE_TIME: dateTime,
    };
  }

  static Map<String, dynamic> serializeFromEvent(
      Map<DateTime, List<dynamic>> event) {
    //The order of these elements corresponds to the
    //convertToEvent() function below
    List<dynamic> info = event.values.elementAt(0);

    return <String, dynamic>{
      EMAIL: info[1],
      TITLE: info[2],
      LOCATION: info[3],
      DATE_TIME: event.keys.elementAt(0),
    };
  }

  static Appointment deserialize(Map<String, dynamic> data, String docID) {
    Timestamp ts = data[Appointment.DATE_TIME];
    DateTime date = ts.toDate();
    return Appointment(
        docID: docID,
        email: data[Appointment.EMAIL],
        title: data[Appointment.TITLE],
        location: data[Appointment.LOCATION],
        dateTime: date);
  }

  String getTimeandLocation() {
    return DateFormat.jm().format(this.dateTime).toString() +
        '\n' +
        this.location;
  }

  static const EMAIL = 'email';
  static const TITLE = 'title';
  static const LOCATION = 'location';
  static const DATE_TIME = 'dateTime';
  static const COLLECTION = 'appointment';
}
