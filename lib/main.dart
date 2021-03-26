import 'package:Capstone/Screen/Social%20Activities/activity_add_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/activity_edit_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/location_add_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/location_edit_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/socialActivity_add_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/socialActivity_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/social_contact_add_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/social_contact_edit_screen.dart';
import 'package:Capstone/Screen/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/constant.dart';
import 'Screen/Social Activities/socialActivity_edit_screen.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        ActivityAddScreen.routeName: (context) => ActivityAddScreen(),
        ActivityEditScreen.routeName: (context) => ActivityEditScreen(),
        SocialContactAddScreen.routeName: (context) => SocialContactAddScreen(),
        SocialContactEditScreen.routeName: (context) =>
            SocialContactEditScreen(),
        LocationAddScreen.routeName: (context) => LocationAddScreen(),
        LocationEditScreen.routeName: (context) => LocationEditScreen(),
        SocialActivityAddScreen.routeName: (context) =>
            SocialActivityAddScreen(),
        SocialActivityEditScreen.routeName: (context) =>
            SocialActivityEditScreen(),
        SocialActivityScreen.routeName: (context) => SocialActivityScreen(),
      },
    );
  }
}
