import 'package:Capstone/Model/medical_history.dart';
import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatefulWidget {
  static const routeName = '/medicalInfoScreen';

  @override
  State<StatefulWidget> createState() {
    return _MedicalHistoryState();
  }
}

class _MedicalHistoryState extends State<MedicalHistoryScreen> {
  _Controller con;
  BuildContext context;
  MedicalHistory history = new MedicalHistory();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medical History")),
      body: ListView.builder(
        itemCount: history.conditions.length,
        itemBuilder: (BuildContext context, int index) {
          return RaisedButton(
            child: Text(history.conditions[index].name),
            onPressed: () => con.updateCondition(index),
          );
        },
      ),
    );
  }
}

class _Controller {
  _MedicalHistoryState _state;
  _Controller(this._state);
  MedicalHistory history = new MedicalHistory();

  void updateCondition(int i) {
    print(
        'Before press:  ${history.conditions[i].name} = ${history.conditions[i].isSelected}');
    history.conditions[i].isSelected = !history.conditions[i].isSelected;
    print(
        'After press:  ${history.conditions[i].name} = ${history.conditions[i].isSelected}');
  }
}
