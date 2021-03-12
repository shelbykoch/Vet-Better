import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editMed_screen.dart';

class MyMedicationScreen extends StatefulWidget {
  static const routeName = '/myMedicationScreen';

  @override
  State<StatefulWidget> createState() {
    return _MyMedicationState();
  }
}

class _MyMedicationState extends State<MyMedicationScreen> {
  _Controller con;
  List<Medication> medication;
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
            medication.length == 0
                ? Text('Add Medications to your list')
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: medication.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RaisedButton(
                        child: Text(medication[index].medName),
                        onPressed: con.medicationInfoRoute,
                      );
                    }),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('Add New Medication'),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: con.medicationInfoRoute,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _MyMedicationState _state;
  _Controller(this._state);

  void medicationInfoRoute() async {
    // First we will load the medication info associated with the account to pass to the screen
    // if it doesn't exist in the database we will created a new one and append
    // the email then pass to the screen
    List<Medication> medication =
        await FirebaseController.getMedicationList(_state.user.email);
    Navigator.pushNamed(_state.context, EditMedScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_MEDICATION_INFO: medication,
    });
    print(_state.user);
  }
}
