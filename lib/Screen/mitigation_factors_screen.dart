import 'package:Capstone/Model/mitigation_factors.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:flutter/material.dart';

class MitigationScreen extends StatefulWidget {
  static const routeName = 'riskScreen';
  @override
  State<StatefulWidget> createState() {
    return _MitigationState();
  }
}

class _MitigationState extends State<MitigationScreen> {
  _Controller con;
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
          itemCount: con.mitigationFactors.factors.length,
          itemBuilder: (BuildContext context, index) => Container(
            color: con.mitigationFactors.factors[index].isSelected == false
                ? Colors.grey[800]
                : Colors.blue[800],
            child: ListTile(
              trailing: con.mitigationFactors.factors[index].isSelected == false
                  ? Icon(Icons.check_box_outline_blank)
                  : Icon(Icons.check_box),
              title: Text(con.mitigationFactors.factors[index].name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${con.mitigationFactors.factors[index].description}'),
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
  MitigationFactors mitigationFactors =
      new MitigationFactors(); //get list of mitigation factors

  void onTap(int index) async {
    mitigationFactors.factors[index].isSelected =
        !mitigationFactors.factors[index].isSelected;
    _state.render(() {}); //render changes on screen
  }

  void continueButton() async {
    int sum = 0;
    sum = mitigationFactors.getScore();

    MyDialog.info(
      //display popup message (temporary)
      context: _state.context,
      title: 'Mitigation Score',
      content: 'Your mitigation score is $sum.',
    );
  }
}
