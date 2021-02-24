import 'package:Capstone/Model/psychiatric_history.dart';
import 'package:flutter/material.dart';

class PsychHistoryScreen extends StatefulWidget {
  static const routeName = '/psychInfoScreen';

  @override
  State<StatefulWidget> createState() {
    return _PsychHistoryState();
  }
}

class _PsychHistoryState extends State<PsychHistoryScreen> {
  _Controller con;
  BuildContext context;
  PsychiatricHistory history = new PsychiatricHistory();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Psych History")),
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
  _PsychHistoryState _state;
  _Controller(this._state);
  PsychiatricHistory history = new PsychiatricHistory();

  void updateCondition(int i) {
    print(
        'Before press:  ${history.conditions[i].name} = ${history.conditions[i].isSelected}');
    history.conditions[i].isSelected = !history.conditions[i].isSelected;
    print(
        'After press:  ${history.conditions[i].name} = ${history.conditions[i].isSelected}');
  }
}
