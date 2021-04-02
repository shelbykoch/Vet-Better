import 'dart:async';
import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/views/testNotifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  static Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    //final String timeZoneName = await platform.invokeMethod('getTimeZoneName');
    //tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<void> dailyQuestionsNotification() async {
    // sends a notification at 10am every day.
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Reminder:',
        'Answer your daily questions!',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              '1',
              'Daily Questions Notification',
              'Sends a reminder everyday to answer the daily questions'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> medicationNotification(String email) async {
    List<Medication> medication =
        await FirebaseController.getMedicationList(email);
    if (medication == null) return; //Return if meds do not exist
    for (Medication med in medication) {
      if (med.timesDaily > 0) {
        print("timesDaily > 0: ${med.timesDaily.toString()}");
        await flutterLocalNotificationsPlugin.zonedSchedule(
            2,
            'Reminder:',
            'Take your morning medication',
            _nextInstanceOfEightAM(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  '2',
                  'Daily Morning Medication Reminder',
                  'Sends a reminder to take morning meds each day'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      if (med.timesDaily > 1) {
        print("timesDaily > 1: ${med.timesDaily.toString()}");

        await flutterLocalNotificationsPlugin.zonedSchedule(
            3,
            'Reminder:',
            'Take your afternoon medication',
            _nextInstanceOfNoon(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  '3',
                  'Daily Afternoon Medication Reminder',
                  'Sends a reminder to take afternoon meds each day'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      if (med.timesDaily > 2) {
        print("timesDaily > 2: ${med.timesDaily.toString()}");
        await flutterLocalNotificationsPlugin.zonedSchedule(
            4,
            'Reminder:',
            'Take your evening medication',
            _nextInstanceOfEightPM(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  '4',
                  'Daily Evening Medication Reminder',
                  'Sends a reminder to take evening meds each day'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
    }
  }

  // static Future<void> refillNotifications(String email) async {
  //   List<Medication> medication =
  //       await FirebaseController.getMedicationList(email);
  //   for (Medication med in medication) {
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //           4,
  //           'Reminder:',
  //           'Time to refill medication ${medication.medName}',
  //           _nextInstanceOfEightPM(),
  //           const NotificationDetails(
  //             android: AndroidNotificationDetails(
  //                 '4',
  //                 'Daily Evening Medication Reminder',
  //                 'Sends a reminder to take evening meds each day'),
  //           ),
  //           androidAllowWhileIdle: true,
  //           uiLocalNotificationDateInterpretation:
  //               UILocalNotificationDateInterpretation.absoluteTime,
  //           matchDateTimeComponents: DateTimeComponents.time);
  //     }
  //   }

  static tz.TZDateTime _nextInstanceOfEightAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 15);
    print("now: ${now}");
    print("8am: ${scheduledDate}");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
      print("8am: ${scheduledDate}");
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 30);
    print("10am: ${scheduledDate}");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
      print("10am: ${scheduledDate}");
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfNoon() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 30);
    print("now: ${now}");
    print("12pm: ${scheduledDate}");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
      print("12pm: ${scheduledDate}");
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfEightPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 45);
    print("now: ${now}");
    print("8pm: ${scheduledDate}");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
      print("8pm: ${scheduledDate}");
    }
    return scheduledDate;
  }

// Future<void> cancelNotification() async {
//   await flutterLocalNotificationsPlugin.cancel(0);
// }
}
