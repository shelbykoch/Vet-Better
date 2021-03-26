import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_dialog.dart';

class ContactEditScreen extends StatefulWidget {
  static const routeName = '/contactEditScreen';
  @override
  State<StatefulWidget> createState() {
    return _ContactEditScreenState();
  }
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  _Controller con;
  BuildContext context;
  Contact _contact;
  User _user;
  var formKey = GlobalKey<FormState>();

  _ContactEditScreenState() {
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    _user ??= arg[Constant.ARG_USER];
    _contact = arg[Constant.ARG_CONTACT];
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.save, color: Colors.white),
            label: _contact.docID == null
                ? Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
            onPressed: con.saveContact,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                autocorrect: false,
                validator: con.validateName,
                initialValue: _contact.name != null ? _contact.name : "",
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone number',
                ),
                keyboardType: TextInputType.phone,
                autocorrect: false,
                validator: con.validatePhone,
                initialValue:
                    _contact.phoneNumber != null ? _contact.phoneNumber : "",
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                autocorrect: false,
                validator: con.validateAddress,
                initialValue: _contact.address != null ? _contact.address : "",
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Notes',
                ),
                keyboardType: TextInputType.multiline,
                autocorrect: false,
                initialValue: _contact.notes != null ? _contact.notes : "",
                onChanged: con.onNotesChanged,
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    child: Text("Delete"),
                    onPressed: () {
                      con.deleteContact();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _ContactEditScreenState _state;
  _Controller(this._state);

  String validateName(String value) {
    if (value == null || value.isEmpty)
      return 'Enter an contact name';
    else {
      _state._contact.name = value;
      return null;
    }
  }

  String validatePhone(String value) {
    if (value == null || value.isEmpty || value.length < 10)
      return 'Enter an contact phone number';
    else {
      _state._contact.phoneNumber = value;
      return null;
    }
  }

  String validateAddress(String value) {
    if (value == null || value.isEmpty)
      return 'Enter an contact address';
    else {
      _state._contact.address = value;
      return null;
    }
  }

  void onNotesChanged(String value) {
    _state._contact.notes = value;
  }

  void saveContact() async {
    if (!_state.formKey.currentState.validate() || _state._contact.type == null)
      return;

    _state.formKey.currentState.save();
    AppDialog.showProgressBar(_state.context);

    try {
      if (_state._contact.docID == null || _state._contact.docID.isEmpty) {
        String docID = await FirebaseController.addContact(_state._contact);
        _state._contact.docID = docID;
      } else
        FirebaseController.updateContact(_state._contact);
      Navigator.pop(_state.context); //dispose contact detail screen
    } catch (e) {
      AppDialog.popProgressBar(_state.context);
      AppDialog.info(
          context: _state.context,
          title: 'Save contact process failed',
          message: e.message != null ? e.message : e.toString(),
          action: () => {
                Navigator.pop(_state.context),
              });
      return;
    }
  }

  void deleteContact() async {
    try {
      await FirebaseController.deleteContact(_state._contact.docID);
      Navigator.pop(_state.context); //dispose progress dialog
      Navigator.pop(_state.context); //dispose contact detail screen
      _state.render(() {});
    } catch (e) {
      AppDialog.info(
          context: _state.context,
          title: 'Delete error',
          message: e.message ?? e.toString(),
          action: () => {
                Navigator.pop(_state.context),
              });
    }
  }
}
