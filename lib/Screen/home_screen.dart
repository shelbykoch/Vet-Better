import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Screen/factor_screen.dart';
import 'package:Capstone/Screen/myMedication_screen.dart';
import 'package:Capstone/Screen/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int _navIndex = 0;

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
                leading: Icon(Icons.person),
                title: Text('Personal information'),
                onTap: con.personalInfoRoute,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        body: con._buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cogs),
              label: 'Health Factors',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.users),
              label: 'People & Resources',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendarAlt),
              label: 'Calendar & Meds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock_open),
              label: 'Feel Good Vault',
            ),
          ],
          currentIndex: _navIndex,
          selectedItemColor: Color.fromRGBO(77, 225, 225, 90),
          onTap: con._onTabTapped,
        ),
      ),
    );
  }
}

class _Controller {
  _UserHomeState _state;
  _Controller(this._state);

//--------------------------Nav Bar----------------------------------//

  void _onTabTapped(index) {
    //Changes navigation state in page
    _state.render(() {
      _state._navIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_state._navIndex) {
      //Factors - med & psych history, mitigation strats, risk factors
      case 0:
        return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () =>
                      factorRoute(ListType.MedicalHistory, "Medical History"),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.userMd),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Medical History"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () =>
                      factorRoute(ListType.PsychHistory, "Psychiatric History"),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.brain),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Psychiatric History"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () =>
                      factorRoute(ListType.RiskFactors, "Risk Factors"),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.chartBar),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Risk Factors"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => factorRoute(
                      ListType.MitigationFactors, "Mitigation Factors"),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.projectDiagram),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Mitigation Factors"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () =>
                      factorRoute(ListType.WarningSigns, "Warning Signs"),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.exclamationTriangle),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Warning Signs"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => factorRoute(
                      ListType.CopingStrategies, "Coping Strategies"),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.hiking),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Coping Strategies"),
                      )
                    ],
                  ),
                ),
              ),
            ]);
      //Social activities, people to reach out to, emergency contacts
      case 1:
        return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => {},
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.users),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Social Activities"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => {},
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.comments),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Reach Out"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => {},
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.ambulance),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Emergency Contact"),
                      )
                    ],
                  ),
                ),
              ),
            ]);
      //Calendar, appointments, & meds
      case 2:
        return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => calendarRoute(),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.calendarAlt),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Appointments"),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //width: double.infinity,
                child: RaisedButton(
                  onPressed: () => medicationInfoRoute(),
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: FaIcon(FontAwesomeIcons.prescriptionBottleAlt),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text("Medications"),
                      )
                    ],
                  ),
                ),
              ),
            ]);
      //Feel good vault
      case 3:
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
          child: ListView(children: <Widget>[Text('Feel good vault')]),
        );
    }
  }

  Widget _buildGrid() {}

//------------------------HOME SCREEN ROUTING---------------------------//

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

/*

Padding(
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
          ]),
        )
        */
