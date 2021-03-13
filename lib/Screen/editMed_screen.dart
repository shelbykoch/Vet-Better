import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/myMedication_screen.dart';
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
  User user;
  Medication medicationInfo;
  List<Medication> medication;
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
    medication ??= args[Constant.ARG_MEDICATION_LIST];
    medicationInfo ??= args[Constant.ARG_MEDICATION_INFO];
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
                      initialValue: medicationInfo == null
                      ? 'Medication Name'
                      : medicationInfo.medName,
                      decoration: InputDecoration(
                        hintText: 'Medication Name',
                      ),
                      autocorrect: true,
                      onSaved: con.saveMedName,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Dosage Amount (in mg)',
                      ),
                      initialValue: medicationInfo == null
                      ? 'Dosage Amount (in mg)'
                      : medicationInfo.doseAmt,
                      autocorrect: true,
                      onSaved: con.saveDoseAmt,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Number of Times Daily',
                      ),
                      initialValue: medicationInfo == null
                      ? 'Number of Times Daily'
                      : medicationInfo.timesDaily,
                      autocorrect: true,
                      onSaved: con.saveTimesDaily,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Refill Date (mm-dd-yyyy)',
                      ),
                      initialValue: medicationInfo == null
                      ? 'Refill Date (mm-dd-yyyy)'
                      : medicationInfo.refillDate,
                      autocorrect: true,
                      onSaved: con.saveRefillDate,
                    ),
                //     TextFormField(
                // //initialValue: record.title,
                // decoration: InputDecoration(
                //   labelText: 'Date & Time',
                // ),
                // //controller: _dateController,
                // autocorrect: false,
                // controller: _dateTimeController,
                // readOnly: true,
                // onTap: () {
                //   DatePicker.showDateTimePicker(context, showTitleActions: true,
                //       onConfirm: (date) {
                //     _appointment.dateTime = date;
                //     _dateTimeController.text =
                //         DateFormat.yMd().add_jm().format(date);
                //   }, currentTime: DateTime(2021, 03, 12, 09, 00, 00));
                //  },
                // ),
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
    _state.medicationInfo.email = _state.user.email;
    try {
      await FirebaseController.addMedication(_state.medicationInfo);
    } catch (e) {}
    Navigator.of(_state.context).pop();
  }

  void saveMedName(String value) {
    _state.medicationInfo.medName = value;
  }

  void saveDoseAmt(String value) {
    _state.medicationInfo.doseAmt = value;
  }

  void saveTimesDaily(String value) {
    _state.medicationInfo.timesDaily = value;
  }

  void saveRefillDate(String value) {
    _state.medicationInfo.refillDate = value;
  }
}
