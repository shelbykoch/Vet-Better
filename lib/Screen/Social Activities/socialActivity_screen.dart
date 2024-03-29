import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/Screen/Social%20Activities/socialActivity_add_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/socialActivity_edit_screen.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialActivityScreen extends StatefulWidget {
  static const routeName = '/socialActivityScreen';

  @override
  State<StatefulWidget> createState() {
    return _SocialActivityState();
  }
}

class _SocialActivityState extends State<SocialActivityScreen> {
  _Controller con;
  User user;
  List<SocialActivity> socialActivities;
  List<Contact> contacts;
  List<Activity> activities;
  List<Location> locations;
  String title;
  int delIndex;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg[Constant.ARG_USER];
    socialActivities ??= arg[Constant.ARG_SOCIALACTIVITIES];
    contacts ??= arg[Constant.ARG_CONTACTS];
    activities ??= arg[Constant.ARG_ACTIVITIES];
    locations ??= arg[Constant.ARG_LOCATIONS];

    return Scaffold(
      appBar: AppBar(
        title: Text("Social Activities"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: con.delete),
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: con.add,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              socialActivities.length == 0
                  ? Text(
                      '\n Tap the + button above to add a new Social Activity',
                      style: TextStyle(fontSize: 30.0),
                      textAlign: TextAlign.center,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: socialActivities.length,
                      itemBuilder: (BuildContext context, index) => Container(
                        color: con.getColor(index),
                        child: ListTile(
                          title: Text(socialActivities[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ElevatedButton(
                                child: Text('Edit'),
                                onPressed: () => con.edit(index),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black),
                              ),
                            ],
                          ),
                          onTap: () => con.updateFactor(index),
                          onLongPress: () => con.onLongPress(index),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SocialActivityState _state;
  _Controller(this._state);
  int delIndex;

  void add() async {
    await Navigator.pushNamed(_state.context, SocialActivityAddScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void edit(int index) async {
    await Navigator.pushNamed(
        _state.context, SocialActivityEditScreen.routeName,
        arguments: {
          'index': index,
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITY: _state.socialActivities[index],
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void delete() async {
    try {
      SocialActivity socialActivity = _state.socialActivities[delIndex];
      await FirebaseController.deleteSocialActivity(socialActivity);
      _state.socialActivities.removeAt(delIndex);
      _state.render(() {
        delIndex = null;
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void updateFactor(int index) async {
    if (delIndex != null) {
      //cancel delete mode
      _state.render(() => delIndex = null);
      return;
    }
    _state.render(() {}); //render changes on screen
    try {
      await FirebaseController.updateSocialActivity(
          _state.socialActivities[index]);
    } catch (e) {}
  }

  void onLongPress(int index) {
    _state.render(() {
      delIndex = (delIndex == index ? null : index);
    });
    return;
  }

  Color getColor(index) {
    Color result;
    if (delIndex != null && delIndex == index) {
      result = Colors.red[200]; //red is only rendered if long pressed
    } else
      result = Color.fromRGBO(77, 225, 225, 90);

    return result;
  }
}
