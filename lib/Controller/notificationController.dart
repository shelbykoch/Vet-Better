import 'dart:async';
import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/test_screen.dart';
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
        0,
        'Reminder:',
        'Answer your daily questions!',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> medicationNotification(String email) async {
    // sends a notification at 10am every day.
    //the email then pass to the screen
    List<Medication> medication =
        await FirebaseController.getMedicationList(email);
    for (Medication med in medication) {
      if (med.timesDaily > 0) {
        print("timesDaily > 0: ${med.timesDaily.toString()}");
        await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            'Reminder:',
            'Take your morning medication',
            _nextInstanceOfEightAM(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'daily notification channel id',
                  'daily notification channel name',
                  'daily notification description'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      if (med.timesDaily > 1) {
        print("timesDaily > 1: ${med.timesDaily.toString()}");

        await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            'Reminder:',
            'Take your afternoon medication',
            _nextInstanceOfNoon(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'daily notification channel id',
                  'daily notification channel name',
                  'daily notification description'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      //   if (med.timesDaily > 2) {
      //     print("timesDaily > 2: ${med.timesDaily.toString()}");
      //     await flutterLocalNotificationsPlugin.zonedSchedule(
      //         0,
      //         'Reminder:',
      //         'Take your nighlty medication',
      //         _nextInstanceOfEightPM(),
      //         const NotificationDetails(
      //           android: AndroidNotificationDetails(
      //               'daily notification channel id',
      //               'daily notification channel name',
      //               'daily notification description'),
      //         ),
      //         androidAllowWhileIdle: true,
      //         uiLocalNotificationDateInterpretation:
      //             UILocalNotificationDateInterpretation.absoluteTime,
      //         matchDateTimeComponents: DateTimeComponents.time);
      //   }
    }
  }

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
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, 15);
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
