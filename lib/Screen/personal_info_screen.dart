import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Screen/app_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  BuildContext context;
  User user;
  PersonalInfo personalInfo;
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
    personalInfo ??= arg[Constant.ARG_PERSONAL_INFO];
    user ??= arg[Constant.ARG_USER];
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  //initialValue: user.email,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: con.saveName,
                  initialValue: personalInfo.name,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Age',
                  ),
                  onSaved: con.saveAge,
                  initialValue: personalInfo.age,
                ),
                TextFormField(
                  //initialValue: user.email,
                  decoration: InputDecoration(
                    hintText: 'Gender',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: con.saveGender,
                  initialValue: personalInfo.gender,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Sexual orientation',
                  ),
                  onSaved: con.saveSexualOrientation,
                  initialValue: personalInfo.sexualOrientation,
                ),
                TextFormField(
                  //initialValue: user.email,
                  decoration: InputDecoration(
                    hintText: 'Veteran status',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: con.saveVeteranStatus,
                  initialValue: personalInfo.veteranStatus,
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () {
                        con.save();
                        /*
                        Navigator.pushNamed(
                          context,
                          MedicalHistoryScreen.routeName,
                          arguments: {
                            'personalInfo': personalInfo,
                          },
                        );*/
                      }),
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
  _PersonalInfoState _state;
  _Controller(this._state);
  PersonalInfo personalInfo = new PersonalInfo();

  void save() async {
    if (!_state.formKey.currentState.validate()) return; //If invalid, return
    _state.formKey.currentState.save();

    try {
      await FirebaseController.updatePersonalInfo(_state.personalInfo);
    } catch (e) {}
    Navigator.of(_state.context).pop();
  }

  void saveName(String value) {
    _state.personalInfo.name = value;
  }

  void saveAge(String value) {
    _state.personalInfo.age = value;
  }

  void saveGender(String value) {
    _state.personalInfo.gender = value;
  }

  void saveSexualOrientation(String value) {
    _state.personalInfo.sexualOrientation = value;
  }

  void saveVeteranStatus(String value) {
    _state.personalInfo.veteranStatus = value;
  }
}
