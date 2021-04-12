import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LocationAddScreen extends StatefulWidget {
  static const routeName = '/locationAddScreen';
  @override
  State<StatefulWidget> createState() {
    return _LocationAddState();
  }
}

class _LocationAddState extends State<LocationAddScreen> {
  _Controller con;
  User user;
  List<Location> locations;
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
    locations ??= arg[Constant.ARG_LOCATIONS];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Location'),
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
                    hintText: 'Name',
                  ),
                  autocorrect: true,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                  keyboardType: TextInputType.streetAddress,
                  autocorrect: true,
                  onSaved: con.onSavedAddress,
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
  _LocationAddState _state;
  _Controller(this._state);
  String name;
  String address;

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

    var l = Location(
      name: name,
      address: address,
      email: _state.user.email,
    );
    _state.locations.add(l);
    try {
      await FirebaseController.addLocation(l);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.message ?? e.toString(),
      );
    }
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

  void onSavedAddress(String value) {
    this.address = value;
  }
}
