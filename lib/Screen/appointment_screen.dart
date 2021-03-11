import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'app_dialog.dart';

class AppointmentScreen extends StatefulWidget {
  static const routeName = '/appointmentScreen';
  @override
  State<StatefulWidget> createState() {
    return _AppointmentScreenState();
  }
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  _Controller con;
  BuildContext context;
  Appointment _appointment = Appointment();
  var formKey = GlobalKey<FormState>();
  TextEditingController _dateTimeController = TextEditingController();

  _AppointmentScreenState() {
    con = _Controller(this);
    _appointment.email = "test@uco.edu";
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.save, color: Colors.white),
            label: _appointment.docID == null
                ? Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
            onPressed: con.saveAppointment,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                //initialValue: record.imageUrl,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                autocorrect: false,
                validator: con.validateTitle,
              ),
              TextFormField(
                //initialValue: record.title,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
                autocorrect: false,
                validator: con.validateLocation,
              ),
              TextFormField(
                //initialValue: record.title,
                decoration: InputDecoration(
                  labelText: 'Date & Time',
                ),
                //controller: _dateController,
                autocorrect: false,
                controller: _dateTimeController,
                readOnly: true,
                onTap: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    _appointment.dateTime = date;
                    _dateTimeController.text =
                        DateFormat.yMd().add_jm().format(date);
                  }, currentTime: DateTime(2021, 03, 12, 09, 00, 00));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'A reminder will be sent the day before your appointment.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
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
  _AppointmentScreenState _state;
  _Controller(this._state);

  String validateTitle(String value) {
    if (value == null || value.isEmpty)
      return 'Enter an appointment title';
    else {
      _state._appointment.title = value;
      return null;
    }
  }

  String validateLocation(String value) {
    if (value == null || value.isEmpty)
      return 'Enter an appointment location';
    else {
      _state._appointment.location = value;
      return null;
    }
  }

  String validateTime(String value) {
    try {
      _state._appointment.dateTime = DateTime.parse(value);
    } catch (e) {
      return 'Please enter a valid time';
    }
    return null;
  }

  void saveAppointment() {
    if (!_state.formKey.currentState.validate()) return;

    _state.formKey.currentState.save();
    AppDialog.showProgressBar(_state.context);

    try {
      if (_state._appointment.docID == null ||
          _state._appointment.docID.isEmpty)
        FirebaseController.addAppointment(_state._appointment);
      else
        FirebaseController.updateAppointment(_state._appointment);
      Navigator.pop(_state.context); //dispose progress dialog
      Navigator.pop(_state.context); //dispose appointment detail screen
    } catch (e) {
      AppDialog.popProgressBar(_state.context);
      AppDialog.info(
          context: _state.context,
          title: 'Save appointment process failed',
          message: e.message != null ? e.message : e.toString(),
          action: () => {
                Navigator.pop(_state.context),
              });

      return; //cease login process
    }
  }
}
