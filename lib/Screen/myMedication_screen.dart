import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personalInfo.dart';
import 'package:flutter/material.dart';

import 'editMed_screen.dart';

class MyMedicationScreen extends StatefulWidget {
  static const routeName = '/MyMedicationScreen';

  @override
  State<StatefulWidget> createState() {
    return _MyMedicationState();
  }
}

class _MyMedicationState extends State<MyMedicationScreen> {
  _Controller con;
  BuildContext context;
  Medication medication = new Medication();
  //PersonalInfo personalInfo;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  Widget build(BuildContext context) {
    //Map arg = ModalRoute.of(context).settings.arguments;
    //medication ??= arg['medication'];

    return Scaffold(
      appBar: AppBar(title: Text("My Medication")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text('Add New Medication'),
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditMedScreen.routeName,
                );
              },
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
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              EditMedScreen.routeName,
                            );
                          });
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
  Medication medication;

  void addMedName(String medName) {
    String medName;
    _state.medication.medName = medName;
  }
}
