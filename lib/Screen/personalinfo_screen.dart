import 'package:Capstone/Model/personalInfo.dart';
import 'package:flutter/material.dart';

import 'medicalhistory_screen.dart';

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
  var formKey = GlobalKey<FormState>();
  PersonalInfo personalInfo = new PersonalInfo();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    personalInfo ??= arg['personalInfo'];
    return Scaffold(
      appBar: AppBar(title: Text('Personal Information')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: personalInfo.info.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextFormField(
                    decoration: InputDecoration(
                      hintText: personalInfo.info[index].fieldName,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(
                height: 100.0,
              ),
              RaisedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    con.updateScore();
                    Navigator.pushNamed(
                      context,
                      MedicalHistoryScreen.routeName,
                      arguments: {
                        'personalInfo': personalInfo,
                      },
                    );
                  }),
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
  PersonalInfo personalInfo = new PersonalInfo();

  void updateScore() {
    int score;
    score = personalInfo.getScore();
    _state.personalInfo.riskScore = score;
    print('Score: ${_state.personalInfo.riskScore}');
  }
}
