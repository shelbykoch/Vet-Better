import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'factor_screen.dart';

class FactorAddScreen extends StatefulWidget {
  static const routeName = 'FactorAddScreen';
  @override
  State<StatefulWidget> createState() {
    return _FactorAddState();
  }
}

enum SeverityLevel { moderate, severe }

class _FactorAddState extends State<FactorAddScreen> {
  _Controller con;
  User user;
  String title;
  List<Factor> factors;
  SeverityLevel _character = SeverityLevel.moderate;
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
    factors ??= arg[Constant.ARG_FACTORS];
    title ??= arg[Constant.ARG_FACTOR_TITLE];

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
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                  autocorrect: true,
                  onSaved: con.onSavedDescription,
                ),
                ListTile(
                  title: const Text('Moderate'),
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
                  title: const Text('Severe'),
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
  _FactorAddState _state;
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
      email: _state.user.email,
      isSelected: true,
    );
    _state.factors.add(f);
    try {
      await FirebaseController.addFactor(f);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.message ?? e.toString(),
      );
    }
    Navigator.pop(_state.context);
    Navigator.pushReplacementNamed(_state.context, FactorScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_FACTORS: _state.factors,
          Constant.ARG_FACTOR_TITLE: _state.title,
        });
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
