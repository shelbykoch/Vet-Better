import 'package:Capstone/Model/medical_history.dart';
import 'package:flutter/material.dart';

import 'psychhistory_screen.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text("Please select all that apply"),
            SizedBox(height: 20.0),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: history.conditions.length,
              itemBuilder: (BuildContext context, int index) {
                return RaisedButton(
                  child: Text(history.conditions[index].name),
                  color: history.conditions[index].isSelected
                      ? Color.fromRGBO(77, 225, 225, 90)
                      : Colors.grey,
                  onPressed: () {
                    con.updateCondition(index);
                    setState(() {
                      history.conditions[index].isSelected =
                          !history.conditions[index].isSelected;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 100.0),
            RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  con.updateScore();
                  Navigator.pushNamed(context, PsychHistoryScreen.routeName);
                }),
          ],
        ),
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

  void updateScore() {
    int score;
    score = history.getScore();
    print('Score: $score');
  }
}