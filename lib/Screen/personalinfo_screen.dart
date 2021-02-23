import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  static const routeName = '/personalInfoScreen';

  @override
  State<StatefulWidget> createState() {
    return _PersonalInfoState();
  }
}

class _PersonalInfoState extends State<PersonalInfoScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('PersonalInfo Screen')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Name'),
                autocorrect: false,
                keyboardType: TextInputType.name,
                validator: con.validatorName,
                onSaved: con.onSavedName,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Age'),
                autocorrect: true,
                keyboardType: TextInputType.number,
                validator: con.validatorAge,
                onSaved: con.onSavedAge,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Gender'),
                autocorrect: true,
                keyboardType: TextInputType.text,
                validator: con.validatorGender,
                onSaved: con.onSavedGender,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Religious Affiliation'),
                autocorrect: true,
                keyboardType: TextInputType.text,
                validator: con.validatorReligion,
                onSaved: con.onSavedReligion,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Sexual Orientaion'),
                autocorrect: false,
                keyboardType: TextInputType.text,
                validator: con.validatorSexualOrientation,
                onSaved: con.onSavedSexualOrientation,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Military History'),
                autocorrect: false,
                keyboardType: TextInputType.text,
                validator: con.validatorMilitaryHistory,
                onSaved: con.onSavedMilitaryHistory,
              ),
              SizedBox(
                height: 100.0,
              ),
              RaisedButton(
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: con.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _PersonalInfoState _state;
  _Controller(this._state);
  String name;
  String age;
  String gender;
  String religion;
  String sexualOrientation;
  String militaryHistory;

  String validatorName(String value) {
    if (value == null) {
      return 'please enter your name';
    } else {
      return null;
    }
  }

  void onSavedName(String value) {
    this.name = value;
  }

  String validatorAge(String value) {
    if (value == null) {
      return 'please enter your age';
    } else {
      return null;
    }
  }

  void onSavedAge(String value) {
    this.age = value;
  }

  String validatorGender(String value) {
    if (value == null) {
      return 'please enter your gender';
    } else {
      return null;
    }
  }

  void onSavedGender(String value) {
    this.gender = value;
  }

  String validatorReligion(String value) {
    if (value == null) {
      return 'please enter your religion';
    } else {
      return null;
    }
  }

  void onSavedReligion(String value) {
    this.religion = value;
  }

  String validatorSexualOrientation(String value) {
    if (value == null) {
      return 'please enter your gender';
    } else {
      return null;
    }
  }

  void onSavedSexualOrientation(String value) {
    this.sexualOrientation = value;
  }

  String validatorMilitaryHistory(String value) {
    if (value == null) {
      return 'please enter your military history';
    } else {
      return null;
    }
  }

  void onSavedMilitaryHistory(String value) {
    this.militaryHistory = value;
  }

  void submit() {
    if (!_state.formKey.currentState.validate()) {
      return;
    }
    _state.formKey.currentState.save();
  }
}
