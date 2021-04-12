import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/notification_settings.dart';
import 'package:Capstone/Screen/home_screen.dart';
import 'package:Capstone/views/testNotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen(
    this.payload, {
    Key key,
  }) : super(key: key);
  final String payload;
  static const routeName = '/notificationSettingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _NotificationSettingsState();
  }
}

class _NotificationSettingsState extends State<NotificationSettingsScreen> {
  _Controller con;
  User user;
  List<NotificationSettings> settings;
  int notificationIndex;
  var formKey = GlobalKey<FormState>();
  String _payload;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    _payload = widget.payload;
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // render(() {});
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
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: con.save,
            label: Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          settings == null
              ? Text("Page Error, Check back later.")
              : Form(
                  key: formKey,
                  child: Card(
                    color: Colors.grey[800],
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: settings.length,
                        itemBuilder: (BuildContext context, int i) {
                          return Column(
                            children: <Widget>[
                              Text('${settings[i].notificationTitle}'),
                              ToggleSwitch(
                                initialLabelIndex: settings[i].currentToggle,
                                minWidth: 90.0,
                                cornerRadius: 20.0,
                                activeBgColor: Color.fromRGBO(77, 225, 225, 90),
                                activeFgColor: Colors.white,
                                //inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                labels: ['On', 'Off'],
                                onToggle: (index) async {
                                  con.onSavedSetting(
                                      settings[i].notificationIndex, index);
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
        ],
      )),
    );
  }
}

class _Controller {
  _NotificationSettingsState _state;
  _Controller(this._state);
  void save() async {
    if (!_state.formKey.currentState.validate()) return; //If invalid, return

    for (NotificationSettings setting in _state.settings) {
      if (!_state.formKey.currentState.validate()) return; //If invalid, return
      _state.formKey.currentState.save();
      setting.email = _state.user.email;
      await FirebaseController.updateNotificationSetting(setting);
      print('${setting.currentToggle}');
      if (setting.currentToggle == 1) {
        // cancel the notification with id value of zero
        await flutterLocalNotificationsPlugin.cancel(setting.notificationIndex);
      }
    }
    List<NotificationSettings> settings =
        await FirebaseController.getNotificationSettings(_state.user.email);
    if (_state._payload == null) {
      Navigator.pushNamed(_state.context, HomeScreen.routeName, arguments: {
        Constant.ARG_USER: _state.user,
        Constant.ARG_NOTIFICATION_SETTINGS: settings,
      });
    } else {
      Navigator.pop(_state.context);
      Navigator.pop(_state.context);

    }
  }

  void onSavedSetting(int notificationIndex, int toggleValue) {
    _state.settings[notificationIndex].currentToggle = toggleValue;
    print(
        "${_state.settings[notificationIndex].notificationTitle} value: ${_state.settings[notificationIndex].currentToggle}");
  }
}
