import 'package:Capstone/views/mydialog.dart';
import 'package:flutter/material.dart';

class MitigationScreen extends StatefulWidget {
  static const routeName = 'mitigationScreen';
  @override
  State<StatefulWidget> createState() {
    return _MitigationState();
  }
}

class _MitigationState extends State<MitigationScreen> {
  _Controller con;
  List<String> mitFactors = [
    "Factor1",
    "Factor2",
    "Factor3",
    "Factor4",
    "Factor5",
    "Factor6"
  ];

  List<int> mitPoints = [1, 1, 1, 1, 1, 1];

  List<String> mitDescriptions = [
    "Description1",
    "Description2",
    "Description3",
    "Description4",
    "Description5",
    "Description6"
  ];

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mitigation Factors'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save),
          label: Text("Save"),
          onPressed: con.continueButton,
        ),
        body: ListView.builder(
          itemCount: mitFactors.length,
          itemBuilder: (BuildContext context, index) => Container(
            color: con.selections[index] == false
                ? Colors.grey[800]
                : Colors.blue[800],
            child: ListTile(
              trailing: con.selections[index] == false
                  ? Icon(Icons.check_box_outline_blank)
                  : Icon(Icons.check_box),
              title: Text(mitFactors[index]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${mitDescriptions[index]}'),
                ],
              ),
              onTap: () => con.onTap(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _MitigationState _state;
  _Controller(this._state);
  List<bool> selections = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void onTap(int index) async {
    selections[index] ? selections[index] = false : selections[index] = true;
    _state.render(() {});
  }

  void continueButton() async {
    int sum = 0;
    for (bool i in selections) {
      if (i == true) {
        sum++;
      }
    }
    MyDialog.info(
      context: _state.context,
      title: 'Mitigation Score',
      content: 'Your mitigation score is $sum.',
    );
  }
}
