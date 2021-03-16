import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/myMedication_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

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
  TextEditingController dateTimeController;
  DatePicker picker;

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
    medicationInfo ??= args[Constant.ARG_MEDICATION_INFO];
    dateTimeController = TextEditingController(
        text: medicationInfo.refillDate != null
            ? DateFormat.yMd().add_jm().format(medicationInfo.refillDate)
            : "");
    if (medicationInfo == null) medicationInfo = new Medication();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medication"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => con.delete(medicationInfo),
          ),
        ],
      ),
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
                          ? null
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
                          ? null
                          : medicationInfo.doseAmt,
                      autocorrect: true,
                      onSaved: con.saveDoseAmt,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Number of Times Daily',
                      ),
                      initialValue: medicationInfo == null
                          ? null
                          : medicationInfo.timesDaily,
                      autocorrect: true,
                      onSaved: con.saveTimesDaily,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Refills Left',
                      ),
                      initialValue: medicationInfo == null
                          ? null
                          : medicationInfo.refillsLeft,
                      autocorrect: true,
                      onSaved: con.saveRefillsLeft,
                    ),
                    TextFormField(
                      //initialValue: record.title,
                      decoration: InputDecoration(
                        labelText: 'Refill Date',
                      ),
                      //controller: _dateController,
                      autocorrect: false,
                      controller: dateTimeController,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, onConfirm: (date) {
                          medicationInfo.refillDate = date;
                          dateTimeController.text =
                              DateFormat.yMd().add_jm().format(date);
                        }, currentTime: DateTime(2021, 03, 12, 09, 00, 00));
                      },
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
  int index;

  void save() async {
    if (!_state.formKey.currentState.validate()) return; //If invalid, return
    _state.formKey.currentState.save();
    _state.medicationInfo.email = _state.user.email;
    try {
      if (_state.medicationInfo.docId == null) {
        await FirebaseController.addMedication(_state.medicationInfo);
      } else {
        await FirebaseController.updateMedicationInfo(_state.medicationInfo);
      }

      List<Medication> medication =
          await FirebaseController.getMedicationList(_state.user.email);
      
      Navigator.pushNamed(_state.context, MyMedicationScreen.routeName,
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_MEDICATION_LIST: medication,
          });
      //Navigator.of(_state.context).pop(medication);
    } catch (e) {
      print(e);
    }
  }

  void delete(Object object) async {
    Medication medication = object;
    await FirebaseController.deleteMedication(medication.docId);
    List<Medication> medicationList =
        await FirebaseController.getMedicationList(_state.user.email);
    Navigator.pushNamed(_state.context, MyMedicationScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_MEDICATION_LIST: medicationList,
        });
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

  void saveRefillsLeft(String value) {
    _state.medicationInfo.refillsLeft = value;
  }
}
