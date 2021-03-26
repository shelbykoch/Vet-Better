import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialActivityAddScreen extends StatefulWidget {
  static const routeName = '/socialActivityAddScreen';
  @override
  State<StatefulWidget> createState() {
    return _SocialActivityAddState();
  }
}

enum SeverityLevel { moderate, severe }

class _SocialActivityAddState extends State<SocialActivityAddScreen> {
  _Controller con;
  User user;
  String title;
  List<SocialActivity> socialActivities;
  List<Contact> contacts;
  List<Activity> activities;
  List<Location> locations;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg[Constant.ARG_USER];
    socialActivities ??= arg[Constant.ARG_SOCIALACTIVITIES];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Social Activity'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  autocorrect: true,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SocialActivityAddState _state;
  _Controller(this._state);
  String name;
  Contact contact;
  Activity activity;
  Location location;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: 'Validator',
      );
      return; //If invalid, return
    }
    _state.formKey.currentState.save();

    var sa = SocialActivity(
      name: name,
      contact: contact,
      activity: activity,
      location: location,
      email: _state.user.email,
    );
    _state.socialActivities.add(sa);
    try {
      await FirebaseController.addSocialActivity(sa);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.message ?? e.toString(),
      );
    }
    Navigator.pop(_state.context);
    // Navigator.pushReplacementNamed(_state.context, FactorScreen.routeName,
    //     arguments: {
    //       Constant.ARG_USER: _state.user,
    //       Constant.ARG_FACTORS: _state.factors,
    //       Constant.ARG_FACTOR_TITLE: _state.title,
    //     });
  }

  String validatorName(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedName(String value) {
    this.name = value;
  }
}
