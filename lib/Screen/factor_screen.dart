import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User user;
  List<Factor> factors;
  String title;
  int delIndex;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg[Constant.ARG_USER];
    factors ??= arg[Constant.ARG_FACTORS];
    title ??= arg[Constant.ARG_FACTOR_TITLE];

    return Scaffold(
      appBar: title == 'Warning Signs' || title == 'Coping Strategies'
          ? AppBar(
              title: Text(title),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.delete), onPressed: con.delete),
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
              factors.length == 0
                  ? Text(
                      '\n Tap the + button above to add $title.',
                      style: TextStyle(fontSize: 30.0),
                      textAlign: TextAlign.center,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: factors.length,
                      itemBuilder: (BuildContext context, index) => Container(
                        color: con.getColor(index),
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
  int delIndex;

  void add() async {
    await Navigator.pushNamed(_state.context, FactorAddScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_FACTORS: _state.factors,
          Constant.ARG_FACTOR_TITLE: _state.title,
        });
    _state.render(() {});
  }

  void edit(int index) async {
    await Navigator.pushNamed(_state.context, FactorEditScreen.routeName,
        arguments: {
          'index': index,
          Constant.ARG_USER: _state.user,
          Constant.ARG_FACTOR: _state.factors[index],
          Constant.ARG_FACTORS: _state.factors,
          Constant.ARG_FACTOR_TITLE: _state.factors[index].name,
        });
    _state.render(() {});
  }

  void delete() async {
    try {
      Factor factor = _state.factors[delIndex];
      await FirebaseController.deleteFactor(factor);
      _state.factors.removeAt(delIndex);
      _state.render(() {
        delIndex = null;
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void updateFactor(int index) async {
    if (delIndex != null) {
      //cancel delete mode
      _state.render(() => delIndex = null);
      return;
    }
    _state.factors[index].isSelected = !_state.factors[index].isSelected;
    _state.render(() {}); //render changes on screen
    try {
      await FirebaseController.updateFactor(_state.factors[index]);
    } catch (e) {}
  }

  void onLongPress(int index) {
    if (_state.factors[index].listType == ListType.CopingStrategies ||
        _state.factors[index].listType == ListType.WarningSigns) {
      _state.render(() {
        delIndex = (delIndex == index ? null : index);
      });
    } else
      return;
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
                ElevatedButton(
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
      onLongPress: () => onLongPress(index),
    );
  }

  //For factors without a description we will render no subtitle
  Widget noDescription(Factor factor, int index) {
    return ListTile(
      trailing: factor.isSelected == false
          ? Icon(Icons.check_box_outline_blank)
          : Icon(Icons.check_box),
      title: Text(factor.name),
      subtitle: _state.factors[0].listType ==
                  ListType
                      .WarningSigns || //edit button only appears for warning signs and coping strats
              _state.factors[0].listType == ListType.CopingStrategies
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
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
      onLongPress: () => onLongPress(index),
    );
  }

  Color getColor(index) {
    Color result;
    if (delIndex != null && delIndex == index) {
      result = Colors.red[
          200]; //red is only rendered if warning signs or coping strats screen
    } else if (_state.factors[index].isSelected == false) {
      result = Colors.grey[800];
    } else
      result = Color.fromRGBO(77, 225, 225, 90);
    return result;
  }
}
