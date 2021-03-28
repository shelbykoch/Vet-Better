import 'package:Capstone/Controller/notificationController.dart';
import 'package:Capstone/Screen/answer_screen.dart';
import 'package:Capstone/Screen/dailyquestions_screen.dart';
import 'package:Capstone/Screen/forgot_password_screen.dart';
import 'package:Capstone/Screen/notificationsettings_screen.dart';
import 'package:Capstone/views/testNotifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Model/constant.dart';
import 'Controller/notificationController.dart';
import 'Screen/appointment_screen.dart';
import 'Screen/calendar_screen.dart';
import 'Screen/editMed_screen.dart';
import 'Screen/factor_add_screen.dart';
import 'Screen/factor_edit_screen.dart';
import 'Screen/login_screen.dart';
import 'Screen/home_screen.dart';
import 'Screen/factor_screen.dart';
import 'Screen/myMedication_screen.dart';
import 'Screen/personal_info_screen.dart';
import 'Screen/contact_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.configureLocalTimeZone();



  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload = notificationAppLaunchDetails.payload;
    initialRoute = SecondPage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload);
  });


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      theme: ThemeData(
        brightness: Brightness.dark,
        buttonColor: Color.fromRGBO(77, 225, 225, 90),
        accentColor: Color.fromRGBO(77, 225, 225, 90),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Login',
      initialRoute: LoginScreen.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(notificationAppLaunchDetails),
        SecondPage.routeName: (_) => SecondPage(selectedNotificationPayload),
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        FactorScreen.routeName: (context) => FactorScreen(),
        PersonalInfoScreen.routeName: (context) => PersonalInfoScreen(),
        CalendarScreen.routeName: (conext) => CalendarScreen(),
        AppointmentScreen.routeName: (context) => AppointmentScreen(),
        MyMedicationScreen.routeName: (context) => MyMedicationScreen(),
        EditMedScreen.routeName: (context) => EditMedScreen(),
        FactorAddScreen.routeName: (context) => FactorAddScreen(),
        FactorEditScreen.routeName: (context) => FactorEditScreen(),
        DailyQuestionsScreen.routeName: (context) => DailyQuestionsScreen(),
        AnswerScreen.routeName: (context) => AnswerScreen(),
        NotificationSettingsScreen.routeName: (context) => NotificationSettingsScreen(),
        ContactEditScreen.routeName: (context) => ContactEditScreen(),
        ContactListScreen.routeName: (context) => ContactListScreen(),
      },
    );
  }
}
