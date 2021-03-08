import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditMedScreen extends StatefulWidget {
  static const routeName = '/editMedScreen';

  @override
  State<StatefulWidget> createState() {
    return _EditMedState();
  }
}

class _EditMedState extends State<EditMedScreen> {
  _Controller con;
  BuildContext context;
  Medication medication = new Medication();
  User user;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    medication ??= args[Constant.ARG_MEDICATION_INFO];

    return Scaffold(
      appBar: AppBar(title: Text("Add Medication")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Medication Name',
                      ),
                      initialValue: medication.medName,
                      autocorrect: true,
                      // validator: con.validatorMedName,
                      // onSaved: con.onSavedMedName,
                    ),
                    SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () {
                        con.save();
                      },
                  ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _EditMedState _state;
  _Controller(this._state);

 
  void save() async {
    if (!_state.formKey.currentState.validate()) return; //If invalid, return
    _state.formKey.currentState.save();

    try {
      await FirebaseController.updateMedicationInfo(_state.medication);
    } catch (e) {}
    Navigator.of(_state.context).pop();
  } 

  // String validatorMedName(String value) {
  //   if (value.length < 2) {
  //     return 'min 2 chars';
  //   } else
  //     return null;
  // }
  // void onSavedMedName(String value) {
  // _state.medication.medName = value;
  // }
}


