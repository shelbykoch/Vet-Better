import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/notification_settings.dart';
import 'package:Capstone/Screen/home_screen.dart';
import 'package:Capstone/views/testNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NotificationSettingsScreen extends StatefulWidget {
  static const routeName = '/notificationSettingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _NotificationSettingsState();
  }
}

class _NotificationSettingsState extends State<NotificationSettingsScreen> {
  _Controller con;
  User user;
  int initialIndexOne = 0;
  int initialIndexTwo = 0;
  int initialIndexThree = 0;
  int initialIndexFour = 0;
  List<NotificationSettings> settings;
  int notificationIndex;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    render(() {});
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    settings ??= args[Constant.ARG_NOTIFICATION_SETTINGS];
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Settings"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            List<NotificationSettings> settings =
                await FirebaseController.getNotificationSettings(user.email);
            Navigator.pushNamed(context, HomeScreen.routeName, arguments: {
              Constant.ARG_USER: user,
              Constant.ARG_NOTIFICATION_SETTINGS: settings,
            });
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Daily Question Notifications',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          ToggleSwitch(
            initialLabelIndex: initialIndexOne,
            activeBgColor: Color.fromRGBO(77, 225, 225, 90),
            labels: ['On', 'Off'],
            onToggle: (index) async {
              if (index == 0) {
                notificationIndex = initialIndexOne;
                await FirebaseController.updateNotificationSetting(
                    settings[notificationIndex]);
              } else if (index == 1) {
                await flutterLocalNotificationsPlugin.cancel(1);
                await setState(() {
                  initialIndexOne = index;
                });
              }
            },
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Morning Medication Notifications',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          ToggleSwitch(
            initialLabelIndex: initialIndexTwo,
            activeBgColor: Color.fromRGBO(77, 225, 225, 90),
            labels: ['On', 'Off'],
            onToggle: (index) async {
              if (index == 0) {
                print('switched to: $index');
              } else if (index == 1) {
                await flutterLocalNotificationsPlugin.cancel(2);
                setState(() {
                  initialIndexTwo = index;
                });
              }
            },
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Afternoon Medication Notifications',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          ToggleSwitch(
            initialLabelIndex: initialIndexThree,
            activeBgColor: Color.fromRGBO(77, 225, 225, 90),
            labels: ['On', 'Off'],
            onToggle: (index) async {
              if (index == 0) {
                print('switched to: $index');
              } else if (index == 1) {
                await flutterLocalNotificationsPlugin.cancel(3);
                setState(() {
                  initialIndexThree = index;
                });
              }
            },
          ),
          SizedBox(
            height: 25.0,
          ),
          Text(
            'Evening Medication Notifications',
            style: TextStyle(fontSize: 15.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          ToggleSwitch(
            initialLabelIndex: initialIndexFour,
            activeBgColor: Color.fromRGBO(77, 225, 225, 90),
            labels: ['On', 'Off'],
            onToggle: (index) async {
              if (index == 0) {
                print('switched to: $index');
              } else if (index == 1) {
                await flutterLocalNotificationsPlugin.cancel(4);
                setState(() {
                  initialIndexFour = index;
                });
              }
            },
          ),
        ],
      )),
    );
  }
}

class _Controller {
  _NotificationSettingsState _state;
  _Controller(this._state);
}
