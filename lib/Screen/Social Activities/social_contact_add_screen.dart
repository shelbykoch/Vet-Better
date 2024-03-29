import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SocialContactAddScreen extends StatefulWidget {
  static const routeName = '/socialContactAddScreen';
  @override
  State<StatefulWidget> createState() {
    return _SocialContactAddState();
  }
}

class _SocialContactAddState extends State<SocialContactAddScreen> {
  _Controller con;
  User user;
  List<Contact> contacts;
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
    contacts ??= arg[Constant.ARG_CONTACTS];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
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
                  keyboardType: TextInputType.name,
                  autocorrect: true,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  autocorrect: true,
                  onSaved: con.onSavedNumber,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Address',
                  ),
                  keyboardType: TextInputType.streetAddress,
                  autocorrect: true,
                  onSaved: con.onSavedAddress,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Notes',
                  ),
                  autocorrect: true,
                  onSaved: con.onSavedNotes,
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
  _SocialContactAddState _state;
  _Controller(this._state);
  String name;
  String address;
  String phoneNumber;
  String notes;

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

    var c = Contact(
      email: _state.user.email,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      notes: notes,
      type: ContactType.Social,
    );
    _state.contacts.add(c);
    try {
      await FirebaseController.addContact(c);
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

  void onSavedNumber(String value) {
    this.phoneNumber = value;
  }

  void onSavedAddress(String value) {
    this.address = value;
  }

  void onSavedNotes(String value) {
    this.notes = value;
  }
}
