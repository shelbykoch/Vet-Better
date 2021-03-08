import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personalInfo.dart';
import 'package:flutter/material.dart';

class EditMedScreen extends StatefulWidget {
  static const routeName = '/EditMedScreen';

  @override
  State<StatefulWidget> createState() {
    return _EditMedState();
  }
}

class _EditMedState extends State<EditMedScreen> {
  _Controller con;
  BuildContext context;
  Medication medication = new Medication();
  var formKey = GlobalKey<FormState>();
  //PersonalInfo personalInfo;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  Widget build(BuildContext context) {
    // Map arg = ModalRoute.of(context).settings.arguments;
    // medication ??= arg['medication'];

    return Scaffold(
      appBar: AppBar(title: Text("Edit Medication")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form (
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
  Medication medication;
}
