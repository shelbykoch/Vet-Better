import 'package:Capstone/Screen/mitigation_factors_screen.dart';
import 'package:Capstone/Screen/risk_factors_screen.dart';
import 'package:Capstone/Screen/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Model/constant.dart';
import 'Screen/login_screen.dart';
import 'Screen/home_screen.dart';
import 'Screen/medicalhistory_screen.dart';
import 'Screen/psychhistory_screen.dart';

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
        RiskScreen.routeName: (context) => RiskScreen(),
        MitigationScreen.routeName: (context) => MitigationScreen(),
		ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
		MedicalHistoryScreen.routeName: (context) => MedicalHistoryScreen(),
        PsychHistoryScreen.routeName: (context) => PsychHistoryScreen(),
        PersonalInfoScreen.routeName: (context) => PersonalInfoScreen(),
      },
    );
  }
}
