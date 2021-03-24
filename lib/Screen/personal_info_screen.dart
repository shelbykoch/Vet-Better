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
  User user;
  PersonalInfo personalInfo;
  var formKey = GlobalKey<FormState>();
  String chosenGender;
  String chosenOrientaion;
  String chosenReligion;
  String chosenMilitary;

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
                  validator: con.validatorName,
                  initialValue: personalInfo == null
                          ? null
                          : personalInfo.name,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Age',
                  ),
                  onSaved: con.saveAge,
                  initialValue: personalInfo == null
                          ? null
                          : personalInfo.age,
                ),
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: chosenGender,
                  //elevation: 5,
                  iconEnabledColor: Colors.white,
                  items: <String>[
                    'Male',
                    'Female',
                    'Transgender',
                    'Gender Neutral',
                    'Non-binary',
                    'Pangender',
                    'Other',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: 280.0,
                        child: Text(
                          value,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: personalInfo.gender == null
                      ?
                       Text(
                          "Gender",
                        )
                      : Text(personalInfo.gender,
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                  onChanged: (String value) {
                    setState(() {
                      chosenGender = value;
                      personalInfo.gender = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: chosenOrientaion,
                  //elevation: 5,
                  iconEnabledColor: Colors.white,
                  items: <String>[
                    'Heterosexual',
                    'Gay/Lesbian',
                    'Bisexual',
                    'Pansexual',
                    'Asexual',
                    'Other',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: 280.0,
                        child: Text(
                          value,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: personalInfo.sexualOrientation == null
                      ? Text(
                          "Sexual Orientation",
                        )
                      : Text(personalInfo.sexualOrientation,
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                  onChanged: (String value) {
                    setState(() {
                      chosenOrientaion = value;
                      personalInfo.sexualOrientation = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: chosenReligion,
                  //elevation: 5,
                  iconEnabledColor: Colors.white,
                  items: <String>[
                    'Christianity',
                    'Islam',
                    'Judaism',
                    'Hinduism',
                    'Buddism',
                    'Secular/Nonreligious/Agnostic/Athiest',
                    'Other',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: 280.0,
                        child: Text(
                          value,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: personalInfo.religiousAffiliation == null
                      ? 
                      Text(
                          "Religious Affiliation",
                        )
                      : Text(personalInfo.religiousAffiliation,
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                  onChanged: (String value) {
                    setState(() {
                      chosenReligion = value;
                      personalInfo.religiousAffiliation = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: chosenMilitary,
                  //elevation: 5,
                  iconEnabledColor: Colors.white,
                  items: <String>[
                    '1-5 years',
                    '6-10 years',
                    '10+ years',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                        width: 280.0,
                        child: Text(
                          value,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    );
                  }).toList(),
                  hint: personalInfo.veteranStatus == null
                      ? 
                      Text(
                          "Military History",
                        )
                      : Text(personalInfo.veteranStatus,
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold)),
                  onChanged: (String value) {
                    setState(() {
                      chosenMilitary = value;
                      personalInfo.veteranStatus = value;
                    });
                  },
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

  String validatorName(String value) {
    if (value.length < 2) {
      return 'min 2 characters';
    } else
      return null;
  }

}
