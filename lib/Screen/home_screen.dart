import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/personalInfo.dart';
import 'package:Capstone/Screen/medicalhistory_screen.dart';
import 'package:Capstone/Screen/mitigation_factors_screen.dart';
import 'package:Capstone/Screen/personalinfo_screen.dart';
import 'package:Capstone/Screen/psychhistory_screen.dart';
import 'package:Capstone/Screen/risk_factors_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controller/firebase_controller.dart';
import '../Model/constant.dart';

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
  PersonalInfo personalInfo;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    personalInfo = new PersonalInfo();
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    return WillPopScope(
      onWillPop: () => Future.value(false), //Disable android system back button
      child: Scaffold(
        appBar: AppBar(title: Text('Unnamed.')),
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
                onPressed: con.medicalHistoryRoute,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Psychiatric history'),
                onPressed: con.psychiatricHistoryRoute,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Baseline risk'),
                onPressed: con.riskRoute,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Mitigation strategies'),
                onPressed: con.mitigationStrategiesRoute,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Controller {
  _UserHomeState state;
  _Controller(this.state);

  void mitigationStrategiesRoute() {
    Navigator.pushNamed(state.context, MitigationScreen.routeName);
  }

  void riskRoute() {
    Navigator.pushNamed(state.context, RiskScreen.routeName);
  }

  void psychiatricHistoryRoute() {
    Navigator.pushNamed(
      state.context,
      PsychHistoryScreen.routeName,
      arguments: {
        'personalInfo': state.personalInfo,
      },
    );
  }

  void medicalHistoryRoute() {
    Navigator.pushNamed(state.context, MedicalHistoryScreen.routeName,
        arguments: {'personalInfo': state.personalInfo});
  }

  void personalInfoRoute() {
    Navigator.pushNamed(state.context, PersonalInfoScreen.routeName);
  }

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      //do nothing
    }
    Navigator.of(state.context).pop(); //Close app drawer
    Navigator.of(state.context).pop(); //Close home screen
  }
}
