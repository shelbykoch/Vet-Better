import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editMed_screen.dart';

class MyMedicationScreen extends StatefulWidget {
  static const routeName = 'homeScreen/myMedicationScreen';

  @override
  State<StatefulWidget> createState() {
    return _MyMedicationState();
  }
}

class _MyMedicationState extends State<MyMedicationScreen> {
  _Controller con;
  BuildContext context;
  Medication medication = new Medication();
  User user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    medication ??= args[Constant.ARG_MEDICATION_INFO];

    return Scaffold(
      appBar: AppBar(title: Text("My Medication")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text('Add New Medication'),
            FloatingActionButton(
              onPressed: con.medicationInfoRoute,
              child: Icon(Icons.add),
            ),
            medication.medications.length == null
                ? Text('Add Medications to your list')
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: medication.medications.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RaisedButton(
                        child: Text(medication.medications[index].name),
                        onPressed: con.medicationInfoRoute,
                      );
                    })
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _MyMedicationState _state;
  _Controller(this._state);

  void addMedName(String medName) {
    String medName;
    _state.medication.medName = medName;
  }

  void medicationInfoRoute() async {
    // First we will load the medication info associated with the account to pass to the screen
    // if it doesn't exist in the database we will created a new one and append
    // the email then pass to the screen
    Medication medication =
        await FirebaseController.getMedicationInfo(_state.user.email);
    print("user email:");
    print(_state.user.email);
    print(_state.context);
    Navigator.pushNamed(_state.context, EditMedScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_MEDICATION_INFO: medication,
    });
  }
}
