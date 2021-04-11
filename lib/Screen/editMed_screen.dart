import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Controller/notificationController.dart';
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
  int chosenTimesDaily;
  int chosenRefillsLeft;
  String addOrEdit;

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
    addOrEdit ??= args[Constant.ARG_ADD_OR_EDIT];
    medicationInfo != null
        ? dateTimeController = TextEditingController(
            text: medicationInfo.refillDate != null
                ? DateFormat.yMd().add_jm().format(medicationInfo.refillDate)
                : "")
        : dateTimeController = TextEditingController(text: "");
    if (medicationInfo == null) medicationInfo = new Medication();
    return Scaffold(
      appBar: AppBar(
        title: addOrEdit == 'add' ? Text("Add Medication") : Text("Edit Mediction"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => con.delete(medicationInfo),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
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
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton<int>(
                          focusColor: Colors.white,
                          value: chosenTimesDaily,
                          //elevation: 5,
                          iconEnabledColor: Colors.white,
                          items: <int>[1, 2, 3]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: SizedBox(
                                width: 280.0,
                                child: Text(
                                  value.toString(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: medicationInfo.timesDaily == null
                              ? Text(
                                  "Number of Times Taken Daily",
                                )
                              : Text(medicationInfo.timesDaily.toString(),
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold)),
                          onChanged: (int value) {
                            setState(() {
                              chosenTimesDaily = value;
                              medicationInfo.timesDaily = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: DropdownButton<int>(
                          focusColor: Colors.white,
                          value: chosenRefillsLeft,
                          iconEnabledColor: Colors.white,
                          items: <int>[1, 2, 3, 4, 5]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: SizedBox(
                                width: 280.0,
                                child: Text(
                                  value.toString(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            );
                          }).toList(),
                          hint: medicationInfo.refillsLeft == null
                              ? Text(
                                  "Number of refills left",
                                )
                              : Text(medicationInfo.refillsLeft.toString(),
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold)),
                          onChanged: (int value) {
                            setState(() {
                              chosenRefillsLeft = value;
                              medicationInfo.refillsLeft = value;
                            });
                          },
                        ),
                      ),
                      TextFormField(
                        //initialValue: record.title,
                        decoration: InputDecoration(
                          labelText: 'Current Medication Refill Date',
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
      _state.medicationInfo.renewalDate =
          _state.medicationInfo.renewalTime(_state.medicationInfo.refillsLeft);
      _state.medicationInfo.refillDate =
          _state.medicationInfo.refillTime(_state.medicationInfo.refillDate);
      //if(_state.medicationInfo.timesDaily != null) NotificationController.medicationNotification(_state.user.email);
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
}
