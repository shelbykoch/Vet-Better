import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Screen/app_dialog.dart';
import 'package:Capstone/Screen/contact_edit_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'
    as UrlLauncher; //Used to make calls

class ContactListScreen extends StatefulWidget {
  static const routeName = '/contactScreen';

  @override
  State<StatefulWidget> createState() {
    return _ContactListState();
  }
}

class _ContactListState extends State<ContactListScreen> {
  _Controller con;
  User _user;
  List<Contact> _contacts;
  ContactType _contactType;
  String _title;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    _user ??= arg[Constant.ARG_USER];
    _contacts = arg[Constant.ARG_CONTACT_LIST] ?? new List<Contact>();
    _contactType ??= arg[Constant.ARG_CONTACT_TYPE];
    _title ??= arg[Constant.ARG_CONTACT_TITLE];

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              'Add Contact',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => con.createContact(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              SizedBox(height: 20.0),
              _contacts.length == 0
                  ? Text(
                      'Tap the + button above to add a contact.',
                      style: TextStyle(fontSize: 20.0),
                      textAlign: TextAlign.center,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _contacts.length,
                      itemBuilder: (BuildContext context, index) => ListTile(
                        title: Text(_contacts[index].name),
                        subtitle: Text(_contacts[index].phoneNumber),
                        onTap: () => con.editContact(index),
                        trailing: Wrap(
                          children: [
                            IconButton(
                                icon:
                                    Icon(Icons.call, color: Colors.green[800]),
                                onPressed: () =>
                                    con.call(_contacts[index].phoneNumber)),
                          ],
                        ),
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
  _ContactListState _state;
  _Controller(this._state);
  int delIndex;

  void createContact() async {
    Contact contact =
        new Contact.withEmail(_state._user.email, _state._contactType);
    await Navigator.pushNamed(_state.context, ContactEditScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state._user,
          Constant.ARG_CONTACT: contact,
        });
    _state._contacts.add(contact);
    _state.render(() {});
  }

  void editContact(int index) async {
    await Navigator.pushNamed(_state.context, ContactEditScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state._user,
          Constant.ARG_CONTACT: _state._contacts[index],
        });
    if (_state._contacts[index].docID == "deleted")
      _state._contacts.removeAt(index);
    _state.render(() {});
  }

  void call(String phoneNumber) {
    try {
      UrlLauncher.launch('tel://${phoneNumber}');
    } catch (e) {}
  }
}
