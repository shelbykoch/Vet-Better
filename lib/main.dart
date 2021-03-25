import 'package:Capstone/Screen/contact_edit_screen.dart';
import 'package:Capstone/Screen/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/constant.dart';
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
        ContactEditScreen.routeName: (context) => ContactEditScreen(),
        ContactListScreen.routeName: (context) => ContactListScreen(),
      },
    );
  }
}
