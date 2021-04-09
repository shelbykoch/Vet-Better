import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/Screen/Social%20Activities/social_contact_add_screen.dart';
import 'package:Capstone/Screen/Social%20Activities/social_contact_edit_screen.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'activity_add_screen.dart';
import 'activity_edit_screen.dart';
import 'location_add_screen.dart';
import 'location_edit_screen.dart';

class SocialActivityEditScreen extends StatefulWidget {
  static const routeName = '/socialActivityEditScreen';
  @override
  State<StatefulWidget> createState() {
    return _SocialActivityEditState();
  }
}

class _SocialActivityEditState extends State<SocialActivityEditScreen> {
  _Controller con;
  User user;
  SocialActivity socialActivity;
  List<SocialActivity> socialActivities;
  List<Contact> contacts;
  List<Activity> activities;
  List<Location> locations;
  int index;
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
    socialActivity ??= arg[Constant.ARG_SOCIALACTIVITY];
    index ??= arg['index'];
    socialActivities ??= arg[Constant.ARG_SOCIALACTIVITIES];
    contacts ??= arg[Constant.ARG_CONTACTS];
    activities ??= arg[Constant.ARG_ACTIVITIES];
    locations ??= arg[Constant.ARG_LOCATIONS];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${socialActivity.name}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  initialValue: socialActivity.name,
                  autocorrect: true,
                  validator: con.validatorName,
                  onSaved: con.onSavedName,
                ),
                contacts.length != 0
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButton<Contact>(
                              isExpanded: true,
                              value: con.getValue(1),
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (Contact newValue) {
                                setState(() {
                                  con.dropdownValueContacts = newValue;
                                  con.contactIndex = contacts.indexOf(newValue);
                                });
                              },
                              items: contacts
                                  .map(
                                    (Contact contact) =>
                                        DropdownMenuItem<Contact>(
                                      child: Text(contact.name),
                                      value: contact,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: con.addContact),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: con.editContact),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: con.deleteContact),
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          Container(
                            child: Text('No contacts found'),
                            width: 187,
                          ),
                          IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: con.addContact),
                        ],
                      ),
                activities.length != 0
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButton<Activity>(
                              isExpanded: true,
                              value: con.getValue(2),
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (Activity newValue) {
                                setState(() {
                                  con.dropdownValueActivities = newValue;
                                  con.activityIndex =
                                      activities.indexOf(newValue);
                                });
                              },
                              items: activities
                                  .map(
                                    (Activity activity) =>
                                        DropdownMenuItem<Activity>(
                                      child: Text(activity.name),
                                      value: activity,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: con.addActivity),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: con.editActivity),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: con.deleteActivity),
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          Container(
                            child: Text('No activities found'),
                            width: 187,
                          ),
                          IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: con.addActivity),
                        ],
                      ),
                locations.length != 0
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: DropdownButton<Location>(
                              isExpanded: true,
                              value: con.getValue(3),
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: (Location newValue) {
                                setState(() {
                                  con.dropdownValueLocations = newValue;
                                  con.locationIndex =
                                      locations.indexOf(newValue);
                                });
                              },
                              items: locations
                                  .map(
                                    (Location location) =>
                                        DropdownMenuItem<Location>(
                                      child: Text(location.name),
                                      value: location,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: con.addLocation),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: con.editLocation),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: con.deleteLocation),
                        ],
                      )
                    : Row(
                        children: <Widget>[
                          Container(
                            child: Text('No locations found'),
                            width: 187,
                          ),
                          IconButton(
                              icon: Icon(Icons.add_box),
                              onPressed: con.addLocation),
                        ],
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
  _SocialActivityEditState _state;
  _Controller(this._state);
  String name;
  // Contact contact;
  // Activity activity;
  // Location location;
  Contact dropdownValueContacts;
  Activity dropdownValueActivities;
  Location dropdownValueLocations;
  int contactIndex = 0;
  int activityIndex = 0;
  int locationIndex = 0;

  Object getValue(int type) {
    switch (type) {
      case 1:
        {
          if (dropdownValueContacts == null) {
            return _state.socialActivity.contact;
          } else
            return dropdownValueContacts;
        }
        break;
      case 2:
        {
          if (dropdownValueActivities == null) {
            return _state.socialActivity.activity;
          } else
            return dropdownValueActivities;
        }
        break;
      case 3:
        {
          if (dropdownValueLocations == null) {
            return _state.socialActivity.location;
          } else
            return dropdownValueLocations;
        }
        break;
      default:
        {
          return null;
        }
        break;
    }
  }

  void addContact() async {
    await Navigator.pushNamed(_state.context, SocialContactAddScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void editContact() async {
    await Navigator.pushNamed(_state.context, SocialContactEditScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_CONTACT: _state.contacts[contactIndex],
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void deleteContact() async {
    try {
      await FirebaseController.deleteContact(
          _state.contacts[contactIndex].docID);
      _state.contacts.removeAt(contactIndex);
      _state.render(() {
        if (_state.activities.length != 0) {
          dropdownValueContacts = _state.contacts[0];
        }
        contactIndex = 0;
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void addActivity() async {
    await Navigator.pushNamed(_state.context, ActivityAddScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void editActivity() async {
    await Navigator.pushNamed(_state.context, ActivityEditScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_ACTIVITY: _state.activities[activityIndex],
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void deleteActivity() async {
    try {
      await FirebaseController.deleteActivity(_state.activities[activityIndex]);
      _state.activities.removeAt(activityIndex);
      _state.render(() {
        if (_state.activities.length != 0) {
          dropdownValueActivities = _state.activities[0];
        }
        activityIndex = 0;
      });
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete error',
        content: e.message ?? e.toString(),
      );
    }
  }

  void addLocation() async {
    await Navigator.pushNamed(_state.context, LocationAddScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
        });
    _state.render(() {});
  }

  void editLocation() async {
    await Navigator.pushNamed(_state.context, LocationEditScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: _state.socialActivities,
          Constant.ARG_CONTACTS: _state.contacts,
          Constant.ARG_ACTIVITIES: _state.activities,
          Constant.ARG_LOCATIONS: _state.locations,
          Constant.ARG_LOCATION: _state.locations[locationIndex],
        });
    _state.render(() {});
  }

  void deleteLocation() async {
    try {
      await FirebaseController.deleteLocation(_state.locations[locationIndex]);
      _state.locations.removeAt(locationIndex);
      _state.render(() {
        if (_state.activities.length != 0) {
          dropdownValueLocations = _state.locations[0];
        }
        locationIndex = 0;
      });
      _state.render(() {});
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Delete error',
        content: e.message ?? e.toString(),
      );
    }
  }

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

    _state.socialActivity.name = name;
    _state.socialActivity.contact = dropdownValueContacts;
    _state.socialActivity.activity = dropdownValueActivities;
    _state.socialActivity.location = dropdownValueLocations;

    try {
      await FirebaseController.updateSocialActivity(_state.socialActivity);
    } catch (e) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: e.toString(),
      );
      return;
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
}
