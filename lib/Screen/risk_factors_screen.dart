import 'package:Capstone/Model/risk_factors.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:flutter/material.dart';

class RiskScreen extends StatefulWidget {
  static const routeName = 'riskScreen';
  @override
  State<StatefulWidget> createState() {
    return _RiskState();
  }
}

class _RiskState extends State<RiskScreen> {
  _Controller con;
  var formKey = GlobalKey<FormState>();
  //RiskFactors riskFactors = new RiskFactors();

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
          title: Text('Risk Factors'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.save),
          label: Text("Save"),
          onPressed: con.continueButton,
        ),
        body: ListView.builder(
          itemCount: con.riskFactors.factors.length,
          itemBuilder: (BuildContext context, index) => Container(
            color: con.riskFactors.factors[index].isSelected == false
                ? Colors.grey[800]
                : Colors.blue[800],
            child: ListTile(
              trailing: con.riskFactors.factors[index].isSelected == false
                  ? Icon(Icons.check_box_outline_blank)
                  : Icon(Icons.check_box),
              title: Text(con.riskFactors.factors[index].name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${con.riskFactors.factors[index].description}'),
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
  _RiskState _state;
  _Controller(this._state);
  RiskFactors riskFactors = new RiskFactors(); //get list of risk factors

  void onTap(int index) async {
    riskFactors.factors[index].isSelected =
        !riskFactors.factors[index].isSelected;
    _state.render(() {}); //render changes on screen
  }

  void continueButton() async {
    int sum = 0;
    sum = riskFactors.getScore();

    MyDialog.info(
      //display sum of risk factors in popup (temp)
      context: _state.context,
      title: 'Risk Score',
      content: 'Your risk score is $sum.',
    );
  }
}
