import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:flutter/material.dart';

import 'factor_add_screen.dart';
import 'factor_edit_screen.dart';

class FactorScreen extends StatefulWidget {
  static const routeName = '/factorScreen';

  @override
  State<StatefulWidget> createState() {
    return _FactorState();
  }
}

class _FactorState extends State<FactorScreen> {
  _Controller con;
  BuildContext context;
  List<Factor> factors;
  String title;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    factors ??= arg[Constant.ARG_FACTORS];
    title ??= arg[Constant.ARG_FACTOR_TITLE];

    return Scaffold(
      appBar: factors[0].listType == ListType.WarningSigns ||
              factors[0].listType == ListType.CopingStrategies
          ? AppBar(
              title: Text(title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: con.add,
                )
              ],
            )
          : AppBar(title: Text(title.toString())),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text("Please select all that apply"),
              SizedBox(height: 20.0),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: factors.length,
                itemBuilder: (BuildContext context, index) => Container(
                  color: factors[index].isSelected == false
                      ? Colors.grey[800]
                      : Color.fromRGBO(77, 225, 225, 90),
                  child: factors[index].description == ""
                      ? con.noDescription(factors[index], index)
                      : con.withDescription(factors[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _FactorState _state;
  _Controller(this._state);

  void add() {
    Navigator.pushNamed(_state.context, FactorAddScreen.routeName, arguments: {
      Constant.ARG_FACTORS: _state.factors,
      Constant.ARG_FACTOR_TITLE: _state.title,
    });
  }

  void updateFactor(int index) async {
    _state.factors[index].isSelected = !_state.factors[index].isSelected;
    _state.render(() {}); //render changes on screen
    try {
      await FirebaseController.updateFactor(_state.factors[index]);
    } catch (e) {}
  }

  //For factors with a description, we will render a subtitle
  Widget withDescription(Factor factor, int index) {
    return ListTile(
      trailing: factor.isSelected == false
          ? Icon(Icons.check_box_outline_blank)
          : Icon(Icons.check_box),
      title: Text(factor.name),
      subtitle: _state.factors[0].listType == ListType.WarningSigns ||
              _state.factors[0].listType == ListType.CopingStrategies
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${factor.description}'),
                FlatButton(
                  child: Text('Edit'),
                  onPressed: () => edit(index),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${factor.description}'),
              ],
            ),
      onTap: () => updateFactor(index),
    );
  }

  //For factors without a description we will render no subtitle
  Widget noDescription(Factor factor, int index) {
    return ListTile(
      trailing: factor.isSelected == false
          ? Icon(Icons.check_box_outline_blank)
          : Icon(Icons.check_box),
      title: Text(factor.name),
      subtitle: _state.factors[0].listType == ListType.WarningSigns ||
              _state.factors[0].listType == ListType.CopingStrategies
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  child: Text('Edit'),
                  onPressed: () => edit(index),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(""),
              ],
            ),
      onTap: () => updateFactor(index),
    );
  }

  void edit(int index) async {
    await Navigator.pushNamed(_state.context, FactorEditScreen.routeName,
        arguments: {
          Constant.ARG_FACTORS: _state.factors[index],
          Constant.ARG_FACTOR_TITLE: _state.factors[index].name,
        });
  }
}
