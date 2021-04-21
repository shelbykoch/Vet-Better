import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FactorEditScreen extends StatefulWidget {
  static const routeName = 'FactorEditScreen';
  @override
  State<StatefulWidget> createState() {
    return _FactorEditState();
  }
}

enum SeverityLevel { moderate, severe }

class _FactorEditState extends State<FactorEditScreen> {
  _Controller con;
  User user;
  Factor factor;
  List<Factor> factors;
  int index;
  String title;
  SeverityLevel _character;
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
    user ??= arg[Constant.ARG_USER];
    factor ??= arg[Constant.ARG_FACTOR];
    factors ??= arg[Constant.ARG_FACTORS];
    index ??= arg['index'];
    title ??= arg[Constant.ARG_FACTOR_TITLE];

    if (_character == null) {
      factor.score == 1
          ? _character = SeverityLevel.moderate
          : _character = SeverityLevel.severe;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add $title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  autocorrect: true,
                  initialValue: factor.name,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                  autocorrect: true,
                  initialValue: factor.description,
                  onSaved: con.onSavedDescription,
                ),
                ListTile(
                  title: const Text('Low Impact'),
                  leading: Radio<SeverityLevel>(
                    value: SeverityLevel.moderate,
                    groupValue: _character,
                    onChanged: (SeverityLevel value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('High Impact'),
                  leading: Radio<SeverityLevel>(
                    value: SeverityLevel.severe,
                    groupValue: _character,
                    onChanged: (SeverityLevel value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
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
  _FactorEditState _state;
  _Controller(this._state);
  String name;
  String description;
  int score;
  bool severe;
  ListType listType;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: 'Validator',
      );
      return; //If invalid, return
    }
    _state.formKey.currentState.save();
    if (_state._character == SeverityLevel.severe) {
      score = 2;
    } else
      score = 1;
    if (_state.title == "Warning Signs") {
      listType = ListType.WarningSigns;
    } else
      listType = ListType.CopingStrategies;
    var f = Factor(
      name: name,
      description: description,
      score: score,
      listType: listType,
      isSelected: true,
    );
    _state.factors[_state.index] = f;
    try {
      await FirebaseController.updateFactor(f);
    } catch (e) {}
    Navigator.pop(_state.context);
  }

  String validatorName(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedName(String value) {
    this.name = value;
  }

  void onSavedDescription(String value) {
    this.description = value;
  }
}
