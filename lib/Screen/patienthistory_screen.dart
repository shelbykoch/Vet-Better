import 'package:Capstone/Model/history.dart';
import 'package:flutter/material.dart';

class PatientHistoryScreen extends StatefulWidget {
  static const routeName = '/patientHistoryScreen';

  @override
  State<StatefulWidget> createState() {
    return _PatientHistoryState();
  }
}

class _PatientHistoryState extends State<PatientHistoryScreen> {
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
    return Scaffold(
      appBar: AppBar(title: Text('Patient History')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Medical History'),
              Container(
                child: Column(
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text(MedicalHistory.Diabetes.toString().split('.')[1]),
                      value:
                          con.history.medicalHistory[MedicalHistory.Diabetes],
                      onChanged: con.onChangedDiabetes,
                    ),
                    CheckboxListTile(
                      title: Text(MedicalHistory.Cancer.toString().split('.')[1]),
                      value: con.history.medicalHistory[MedicalHistory.Cancer],
                      onChanged: con.onChangedCancer,
                    ),
                    CheckboxListTile(
                      title: Text(MedicalHistory.HeartDisease.toString().split('.')[1]),
                      value: con.history.medicalHistory[MedicalHistory.HeartDisease],
                      onChanged: con.onChangedHeartDisease,
                    ),
                    CheckboxListTile(
                      title: Text(MedicalHistory.HighBloodPressure.toString().split('.')[1]),
                      value: con.history.medicalHistory[MedicalHistory.HighBloodPressure],
                      onChanged: con.onChangedHighBloodPressure,
                    ),
                    CheckboxListTile(
                      title: Text(MedicalHistory.CrohnsDisease.toString().split('.')[1]),
                      value: con.history.medicalHistory[MedicalHistory.CrohnsDisease],
                      onChanged: con.onChangedCrohnsDisease,
                    ),
                    CheckboxListTile(
                      title: Text(MedicalHistory.HighCholestoral.toString().split('.')[1]),
                      value: con.history.medicalHistory[MedicalHistory.HighCholestoral],
                      onChanged: con.onChangedHighCholestoral,
                    ),  
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _PatientHistoryState _state;
  _Controller(this._state);
  History history = History();

  void onChangedDiabetes(bool checked) {
    _state.render(() {
      history.medicalHistory[MedicalHistory.Diabetes] = checked;
    });
  }

  void onChangedCancer(bool checked) {
    _state.render(() {
      history.medicalHistory[MedicalHistory.Cancer] = checked;
    });
  }

  void onChangedHeartDisease(bool checked) {
    _state.render(() {
      history.medicalHistory[MedicalHistory.HeartDisease] = checked;
    });
  }

  void onChangedHighBloodPressure(bool checked) {
    _state.render(() {
      history.medicalHistory[MedicalHistory.HighBloodPressure] = checked;
    });
  }

  void onChangedCrohnsDisease(bool checked) {
    _state.render(() {
      history.medicalHistory[MedicalHistory.CrohnsDisease] = checked;
    });
  }

  void onChangedHighCholestoral(bool checked) {
    _state.render(() {
      history.medicalHistory[MedicalHistory.HighCholestoral] = checked;
    });
  }
}
