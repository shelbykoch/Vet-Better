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
  List<Factor> _factorList;
  Map<ListType, int> _scoreMap;
  int _totalScore = 0;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    _scoreMap = new Map<ListType, int>();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    _factorList ??= arg[Constant.ARG_FACTORS];
    user ??= arg[Constant.ARG_USER];
    con._buildScoreMap();
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
                      title: Text(_scoreMap.keys.elementAt(index).toString()),
                      subtitle: Text(
                          "Score: ${_scoreMap[_scoreMap.keys.elementAt(index)]}"),
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

  void _buildScoreMap() {
    _state._factorList.forEach((factor) {
      if (!_state._scoreMap.keys.contains(factor.listType))
        _state._scoreMap[factor.listType] = 0;
      _state._scoreMap[factor.listType] += factor.score;
      _state._totalScore += factor.score;
    });
  }
}
