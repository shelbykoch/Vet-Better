import 'package:cloud_firestore/cloud_firestore.dart';

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

  Appointment.withEmail(String) {
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

  //The calendar we are using requires a specific object
  //type called an event to display an appointment.
  //This function will convert an appointment into
  //that event object for display
  Map<DateTime, List<dynamic>> convertToEvent() {
    List<dynamic> info = List<dynamic>();
    //Add all info about appointment
    info.add(docID);
    info.add(email);
    info.add(title);
    info.add(location);
    return <DateTime, List<dynamic>>{dateTime: info};
  }

  static const EMAIL = 'email';
  static const TITLE = 'title';
  static const LOCATION = 'location';
  static const DATE_TIME = 'dateTime';
  static const COLLECTION = 'appointment';
}
