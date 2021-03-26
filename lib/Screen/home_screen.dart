import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/Screen/factor_screen.dart';
import 'package:Capstone/Screen/myMedication_screen.dart';
import 'package:Capstone/Screen/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controller/firebase_controller.dart';
import '../Model/constant.dart';
import 'calendar_screen.dart';
import 'factor_add_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<HomeScreen> {
  _Controller con;
  User user;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    return WillPopScope(
      onWillPop: () => Future.value(false), //Disable android system back button
      child: Scaffold(
        appBar: AppBar(title: Text('Vet Better')),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Placeholder'),
                accountEmail: Text(user.email),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
          child: ListView(children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Personal information'),
                onPressed: con.personalInfoRoute,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Medical history'),
                onPressed: () =>
                    con.factorRoute(ListType.MedicalHistory, "Medical History"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('Psychiatric history'),
                  onPressed: () => con.factorRoute(
                      ListType.PsychHistory, "Psychiatric History")),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('Baseline risk'),
                  onPressed: () =>
                      con.factorRoute(ListType.RiskFactors, "Risk Factors")),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Mitigation strategies'),
                onPressed: () => con.factorRoute(
                    ListType.MitigationFactors, "Mitigation Factors"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Medication'),
                onPressed: con.medicationInfoRoute,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Warning Signs'),
                onPressed: () =>
                    con.factorRoute(ListType.WarningSigns, "Warning Signs"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Coping Strategies'),
                onPressed: () => con.factorRoute(
                    ListType.CopingStrategies, "Coping Strategies"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Calendar'),
                onPressed: () => con.calendarRoute(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Social Activities'),
                onPressed: () => con.socialActRoute(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Controller {
  _UserHomeState _state;
  _Controller(this._state);

//------------------------HOME SCREEN ROUTING---------------------------//

  void socialActRoute() async {
    //Request risk factors from database.
    //If Firebase doesn't find the collection then an new version is returned
    List<SocialActivity> socialActivities =
        await FirebaseController.getSocialActivityList(_state.user.email);
    List<Contact> contacts = await FirebaseController.getContactList(
        _state.user.email, ContactType.Social);
    List<Activity> activities =
        await FirebaseController.getActivityList(_state.user.email);
    List<Location> locations =
        await FirebaseController.getLocationList(_state.user.email);

    Navigator.pushNamed(_state.context, FactorScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_SOCIALACTIVITIES: socialActivities,
      Constant.ARG_CONTACTS: contacts,
      Constant.ARG_ACTIVITIES: activities,
      Constant.ARG_LOCATIONS: locations,
    });
  }

  void factorRoute(ListType listType, String title) async {
    //Request risk factors from database.
    //If Firebase doesn't find the collection then an new version is returned
    List<Factor> factors =
        await FirebaseController.getFactorList(_state.user.email, listType);
    if (factors.length == 0 &&
        (listType == ListType.CopingStrategies ||
            listType == ListType.WarningSigns)) {
      Navigator.pushNamed(
          _state.context,
          FactorAddScreen
              .routeName, //nothing in warninig signs or coping strategists list navigate to add screen
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_FACTORS: factors,
            Constant.ARG_FACTOR_TITLE: title,
          });
    } else {
      Navigator.pushNamed(_state.context, FactorScreen.routeName, arguments: {
        Constant.ARG_USER: _state.user,
        Constant.ARG_FACTORS: factors,
        Constant.ARG_FACTOR_TITLE: title,
      });
    }
  }

  void personalInfoRoute() async {
    //First we will load the personal info associated with the account to pass to the screen
    //if it doesn't exist in the database we will created a new one and append
    //the email then pass to the screen
    PersonalInfo info =
        await FirebaseController.getPersonalInfo(_state.user.email);
    Navigator.pushNamed(_state.context, PersonalInfoScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_PERSONAL_INFO: info
        });
  }

  void calendarRoute() async {
    //Map<DateTime, List<dynamic>> function call made here to Firebase to get appointments
    List<Appointment> appointments =
        await FirebaseController.getAppointmentList(_state.user.email);

    Navigator.pushNamed(_state.context, CalendarScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_APPOINTMENTS: appointments,
    });
  }

  void medicationInfoRoute() async {
    //First we will load the medication info associated with the account to pass to the screen
    //if it doesn't exist in the database we will created a new one and append
    //the email then pass to the screen
    List<Medication> medication =
        await FirebaseController.getMedicationList(_state.user.email);
    Navigator.pushNamed(_state.context, MyMedicationScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_MEDICATION_LIST: medication,
        });
  }

  //------------------------APP TRAY ROUTING--------------------------//

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      //do nothing
    }
    Navigator.of(_state.context).pop(); //Close app drawer
    Navigator.of(_state.context).pop(); //Close home screen
  }
}
