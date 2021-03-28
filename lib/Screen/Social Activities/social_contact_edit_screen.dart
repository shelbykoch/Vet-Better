import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialContactEditScreen extends StatefulWidget {
  static const routeName = '/socialContactEditScreen';
  @override
  State<StatefulWidget> createState() {
    return _SocialContactEditState();
  }
}

enum SeverityLevel { moderate, severe }

class _SocialContactEditState extends State<SocialContactEditScreen> {
  _Controller con;
  User user;
  SocialActivity socialActivity;
  List<SocialActivity> socialActivities;
  List<Contact> contacts;
  List<Activity> activities;
  List<Location> locations;
  Contact contact;
  int index;
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
    contacts ??= arg[Constant.ARG_CONTACTS];
    contact ??= arg[Constant.ARG_CONTACT];
    activities ??= arg[Constant.ARG_ACTIVITIES];
    locations ??= arg[Constant.ARG_LOCATIONS];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${contact.name}'),
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
                    hintText: 'Name',
                  ),
                  initialValue: contact.name,
                  keyboardType: TextInputType.name,
                  autocorrect: true,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                  initialValue: contact.phoneNumber,
                  keyboardType: TextInputType.phone,
                  autocorrect: true,
                  onSaved: con.onSavedNumber,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                  initialValue: contact.phoneNumber,
                  keyboardType: TextInputType.streetAddress,
                  autocorrect: true,
                  onSaved: con.onSavedAddress,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Notes',
                  ),
                  initialValue: contact.notes,
                  autocorrect: true,
                  onSaved: con.onSavedNotes,
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
  _SocialContactEditState _state;
  _Controller(this._state);
  String name;
  String address;
  String phoneNumber;
  String notes;

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

    _state.contact.name = name;
    _state.contact.address = address;
    _state.contact.phoneNumber = phoneNumber;
    _state.contact.notes = notes;

    try {
      await FirebaseController.updateContact(_state.contact);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.message ?? e.toString(),
      );
    }
    Navigator.pop(_state.context);
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

  void onSavedNumber(String value) {
    this.phoneNumber = value;
  }

  void onSavedAddress(String value) {
    this.address = value;
  }

  void onSavedNotes(String value) {
    this.notes = value;
  }
}
