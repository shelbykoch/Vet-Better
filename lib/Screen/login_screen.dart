import 'dart:math';

import 'package:Capstone/Controller/notificationController.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/notification_settings.dart';
import 'package:Capstone/Model/picture.dart';
import 'package:Capstone/Model/text_content.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/forgot_password_screen.dart';
import 'package:Capstone/views/testNotifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../Controller/firebase_controller.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';
import 'app_dialog.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:Capstone/Model/factor_score_calculator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);
  static const routeName = '/loginScreen';
  final NotificationAppLaunchDetails notificationAppLaunchDetails;
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  _Controller con;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  TextEditingController _textContoller;
  final FirebaseAuth auth = FirebaseAuth.instance;

  _LoginScreenState() {
    con = _Controller(this);
    final User user = auth.currentUser;
    if (user != null) {
      con._configureDidReceiveLocalNotificationSubject();
      con._configureSelectNotificationSubject();
    }
    con.getNotificationSettings(user);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.people, color: Colors.white),
            label: Text(
              'Create Account',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: con.createAccount,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  'Vet Better',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 50.0,
                      color: Color.fromRGBO(77, 225, 225, 90)),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
              child: Column(
                children: [
                  TextFormField(
                    //initialValue: user.email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: con.validateEmail,
                    onSaved: con.saveEmail,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: con.validatePassword,
                    onSaved: con.savePassword,
                    controller: _textContoller,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text('Login'),
                      onPressed: con.login,
                    ),
                  ),
                  FlatButton(
                    onPressed: con.resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _LoginScreenState state;
  _Controller(this.state);
  String email;
  String password;
  User user;

  void createAccount() {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ));
  }

  String validateEmail(String value) {
    if (value == null || !value.contains('.') || !value.contains('@'))
      return 'Enter a valid email address';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value == "" || value.length <= 6)
      return 'Enter a password';
    else
      return null;
  }

  void saveEmail(String value) {
    email = value;
  }

  void savePassword(String value) {
    password = value;
  }

  void login() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();
    AppDialog.showProgressBar(state.context);

    User user;
    try {
      user = await FirebaseController.login(email: email, password: password);
    } catch (e) {
      AppDialog.popProgressBar(state.context);
      AppDialog.info(
          context: state.context,
          title: 'Login failed',
          message: e.message != null ? e.message : e.toString(),
          action: () => {
                Navigator.pop(state.context),
                state._textContoller.clear(),
              });
      return; //cease login process
    }
    //-------------------Notifications-----------------------------//
    // Fire upon log in.
    var testNow = DateTime.utc(2021, 5, 26);
    var now = DateTime.now();
    var randomNumber = new Random();

    tz.TZDateTime randomDay =
        tz.TZDateTime(tz.local, now.year, now.month, randomNumber.nextInt(30));
    print(randomDay);
    print(now);
    List<NotificationSettings> settings =
        await FirebaseController.getNotificationSettings(user.email);
    try {
      if (settings == null) {
        List<NotificationSettings> settings = new List<NotificationSettings>();
        settings = NotificationSettings.getNotificationSettings(user.email);
        for (NotificationSettings setting in settings) {
          await FirebaseController.addNotificationSetting(setting);
        }

        settings = await FirebaseController.getNotificationSettings(user.email);
        for (NotificationSettings setting in settings) {}
      }
    } catch (e) {
      print("login error: $e");
    }
    try {
      List<Medication> medication =
          await FirebaseController.getMedicationList(user.email);
      if (medication != null) {
        for (Medication med in medication) {
          // Reminder to call your doctor when renewal is needed.
          if (testNow.isAfter(med.renewalDate) == true) {
            await NotificationController.renewalNotifications(user.email);
          }
          // Reminder to refill a prescription.
          if (testNow.isAfter(med.refillDate) == true) {
            await NotificationController.refillNotifications(user.email);
          }
        }
      }
    } catch (e) {
      print("login error: $e");
    }
    // Appointment reminders
    List<Appointment> appointments =
        await FirebaseController.getAppointmentList(user.email);
    if (appointments.length != 0) {
      for (Appointment appt in appointments) {
        if (testNow.isAfter(appt.apptReminderDate) == true) {
          await NotificationController.apptNotifications(user.email);
        }
      }
    }
    FactorScoreCalculator calculator = FactorScoreCalculator();
    int totalScore = await calculator.getTotalScore(user.email);
    if (settings != null) {
      // Feel Good Vault reminders
      if (randomDay == tz.TZDateTime(tz.local, now.year, now.month, now.day) ||
          totalScore < 0) {
        print(now);
        print(totalScore);
        await NotificationController.vaultNotifications(user.email);
      }
      // Daily Questions reminder
      await NotificationController.dailyQuestionsNotification(user.email);
      // Medication reminders
      await NotificationController.medicationNotification(user.email);
    }
    //Load text content
    //Load feel good vault pictures
    List<TextContent> textContent =
        await FirebaseController.getTextContentList(user.email);
    List<Picture> pictures = await FirebaseController.getPictures(user.email);
    Navigator.pop(state.context); //dispose dialog
    Navigator.pushNamed(state.context, HomeScreen.routeName, arguments: {
      Constant.ARG_USER: user,
      Constant.ARG_PICTURE_LIST: pictures,
      Constant.ARG_TEXT_CONTENT_LIST: textContent
    });
  }

  void resetPassword() async {
    Navigator.pushNamed(state.context, ForgotPasswordScreen.routeName);
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: state.context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        HomeScreen(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.pushNamed(state.context, HomeScreen.routeName,
          arguments: {Constant.ARG_USER: user});
    });
  }

  void getNotificationSettings(_user) async {
    if (_user != null) {
      List<NotificationSettings> settings =
          await FirebaseController.getNotificationSettings(_user.email);
      if (settings == null) {
        List<NotificationSettings> settings = new List<NotificationSettings>();
        settings = NotificationSettings.getNotificationSettings(_user.email);
        for (NotificationSettings setting in settings)
          await FirebaseController.addNotificationSetting(setting);
      }
    }
  }
}
