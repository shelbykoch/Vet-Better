import 'dart:async';
import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/notification_settings.dart';
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

  static Future<void> dailyQuestionsNotification(String email) async {
    // sends a notification at 10am every day.
    List<NotificationSettings> settings =
        await FirebaseController.getNotificationSettings(email);
    if (settings[0].currentToggle == 1) {
      // cancel the notification with id value of zero
      await flutterLocalNotificationsPlugin
          .cancel(settings[0].notificationIndex);
      return;
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder:',
        'Answer your daily questions!',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              '0',
              'Daily Questions Notification',
              'Sends a reminder everyday to answer the daily questions'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> medicationNotification(String email) async {
    List<NotificationSettings> settings =
        await FirebaseController.getNotificationSettings(email);
    if (settings[1].currentToggle == 1) {
      await flutterLocalNotificationsPlugin
          .cancel(settings[1].notificationIndex);
      return;
    }
    List<Medication> medication =
        await FirebaseController.getMedicationList(email);
    if (medication == null) return; //Return if meds do not exist
    for (Medication med in medication) {
      if (med.timesDaily > 0) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            1,
            'Reminder:',
            'Take your morning medication',
            _nextInstanceOfEightAM(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  '1',
                  'Daily Morning Medication Reminder',
                  'Sends a reminder to take morning meds each day'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      if (med.timesDaily > 1) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            2,
            'Reminder:',
            'Take your afternoon medication',
            _nextInstanceOfNoon(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  '2',
                  'Daily Afternoon Medication Reminder',
                  'Sends a reminder to take afternoon meds each day'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      if (med.timesDaily > 2) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            3,
            'Reminder:',
            'Take your evening medication',
            _nextInstanceOfEightPM(),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  '3',
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

  // Notifies user 1 week before refills reach zero refill their prescriptions
  static Future<void> refillNotifications(String email) async {
    List<NotificationSettings> settings =
        await FirebaseController.getNotificationSettings(email);
    if (settings[4].currentToggle == 1) {
      // cancel the notification with id value of zero
      await flutterLocalNotificationsPlugin
          .cancel(settings[4].notificationIndex);
      return;
    }
    List<Medication> medication =
        await FirebaseController.getMedicationList(email);
    for (int i = 6; i < medication.length + 6; i++) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          i,
          'Reminder:',
          'Time to refill medication ${medication[i - 6].medName}',
          _nextInstanceOfNoon(),
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'i',
                'Daily Evening Medication Reminder',
                'Sends a reminder to take evening meds each day'),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }
  }

  // Date Times
  static tz.TZDateTime _nextInstanceOfEightAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 15);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 30);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfNoon() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 30);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfEightPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 45);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }
    return scheduledDate;
  }
}
