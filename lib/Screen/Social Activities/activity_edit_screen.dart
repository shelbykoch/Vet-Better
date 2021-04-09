import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityEditScreen extends StatefulWidget {
  static const routeName = '/activityEditScreen';
  @override
  State<StatefulWidget> createState() {
    return _ActivityEditState();
  }
}

class _ActivityEditState extends State<ActivityEditScreen> {
  _Controller con;
  User user;
  Activity activity;
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
    activity ??= arg[Constant.ARG_ACTIVITY];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${activity.name}'),
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
                Text("Think of an action such as go shopping."),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  initialValue: activity.name,
                  autocorrect: true,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                  initialValue: activity.description,
                  autocorrect: true,
                  onSaved: con.onSavedDescription,
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
  _ActivityEditState _state;
  _Controller(this._state);
  String name;
  String description;

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
    _state.activity.name = name;
    _state.activity.description = description;
    try {
      await FirebaseController.updateActivity(_state.activity);
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

  void onSavedDescription(String value) {
    this.description = value;
  }
}
