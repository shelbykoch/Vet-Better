import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/test_notification_screen.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
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
    print("called medicationNotification");
    List<Medication> medication =
        await FirebaseController.getMedicationList(email);
    print("medication.length: ${medication.length.toString()}");
    for (int i = 0; i < medication.length; i++) {
      if (medication[i].timesDaily > 0) {
        print("${medication[i].timesDaily.toString()} > 0");
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
      if (medication[i].timesDaily > 1) {
        print("${medication[i].timesDaily.toString()} > 1");
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
      if (medication[i].timesDaily > 2) {
        print("${medication[i].timesDaily.toString()} > 2");
        await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            'Reminder:',
            'Take your nighlty medication',
            _nextInstanceOfEightPM(),
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
    }
  }

  static tz.TZDateTime _nextInstanceOfEightAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 15);
        print(scheduledDate);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 30);
         print(scheduledDate);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfNoon() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 45);
         print(scheduledDate);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfEightPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 00);
         print(scheduledDate);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

// Future<void> cancelNotification() async {
//   await flutterLocalNotificationsPlugin.cancel(0);
// }
}
