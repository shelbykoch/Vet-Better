import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FactorScoreScreen extends StatefulWidget {
  static const routeName = '/factorScoreScreen';

  @override
  State<StatefulWidget> createState() {
    return _FactorScoreState();
  }
}

class _FactorScoreState extends State<FactorScoreScreen> {
  _Controller con;
  User user;
  Map<ListType, int> _scoreMap;
  Map<ListType, String> _labelMap;
  int _totalScore;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con._buildLabelMap();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    _scoreMap ??= arg[Constant.ARG_FACTOR_SCORE_MAP];
    _totalScore ??= arg[Constant.ARG_FACTOR_SCORE_TOTAL];
    user ??= arg[Constant.ARG_USER];
    return Scaffold(
      appBar: AppBar(title: Text('Factor Scores')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
          child: Expanded(
            child: Column(
              children: <Widget>[
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _scoreMap.length,
                  itemBuilder: (BuildContext context, index) => Container(
                    child: ListTile(
                      title:
                          Text("${_labelMap[_scoreMap.keys.elementAt(index)]}"),
                      subtitle: Text(
                          "Score: ${_scoreMap[_scoreMap.keys.elementAt(index)].toString()}"),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Total"),
                  subtitle: Text("Score: $_totalScore"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _FactorScoreState _state;
  _Controller(this._state);

  void _buildLabelMap() {
    _state._labelMap = Map<ListType, String>();
    _state._labelMap[ListType.MedicalHistory] = "Medical History";
    _state._labelMap[ListType.PsychHistory] = "Psychiatric History";
    _state._labelMap[ListType.RiskFactors] = "Risk Factors";
    _state._labelMap[ListType.MitigationFactors] = "Mitigation Factors";
    _state._labelMap[ListType.CopingStrategies] = "Coping Strategies";
    _state._labelMap[ListType.WarningSigns] = "Warning Signs";
  }
}
