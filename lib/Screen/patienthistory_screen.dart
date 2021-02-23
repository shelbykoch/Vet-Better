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
  History history;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    history = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Patient History')),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Medical History'),
              Container(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: history.medicalHistory[MedicalHistory.Diabetes],
                      onChanged: con.onChangedDiabetes,
                    ),
                    Text(MedicalHistory.Diabetes.toString().split('.')[1]),
                    Checkbox(
                      value: history.medicalHistory[MedicalHistory.Cancer],
                      onChanged: con.onChangedCancer,
                    ),
                    Text(MedicalHistory.Cancer.toString().split('.')[1]),
                    Checkbox(
                      value:
                          history.medicalHistory[MedicalHistory.HeartDisease],
                      onChanged: con.onChangedHeartDisease,
                    ),
                    Text(MedicalHistory.HeartDisease.toString().split('.')[1]),
                    Checkbox(
                      value: history.medicalHistory[MedicalHistory.HighBloodPressure],
                      onChanged: con.onChangedHighBloodPressure,
                    ),
                    Text(MedicalHistory.HighBloodPressure.toString()
                        .split('.')[1]),
                    Checkbox(
                      value:
                          history.medicalHistory[MedicalHistory.CrohnsDisease],
                      onChanged: con.onChangedCrohnsDisease,
                    ),
                    Text(MedicalHistory.CrohnsDisease.toString().split('.')[1]),
                    Checkbox(
                      value: history
                          .medicalHistory[MedicalHistory.HighCholestoral],
                      onChanged: con.onChangedHighCholestoral,
                    ),
                    Text(MedicalHistory.HighCholestoral.toString()
                        .split('.')[1]),
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

  void onChangedDiabetes(bool checked) {
    _state.render(() {
      _state.history.medicalHistory[MedicalHistory.Diabetes] = checked;
    });
  }

  void onChangedCancer(bool checked) {
    _state.render(() {
      _state.history.medicalHistory[MedicalHistory.Cancer] = checked;
    });
  }

  void onChangedHeartDisease(bool checked) {
    _state.render(() {
      _state.history.medicalHistory[MedicalHistory.HeartDisease] = checked;
    });
  }

  void onChangedHighBloodPressure(bool checked) {
    _state.render(() {
      _state.history.medicalHistory[MedicalHistory.HighBloodPressure] = checked;
    });
  }

  void onChangedCrohnsDisease(bool checked) {
    _state.render(() {
      _state.history.medicalHistory[MedicalHistory.CrohnsDisease] = checked;
    });
  }

  void onChangedHighCholestoral(bool checked) {
    _state.render(() {
      _state.history.medicalHistory[MedicalHistory.HighCholestoral] = checked;
    });
  }
}
