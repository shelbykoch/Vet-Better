import 'package:Capstone/Model/constant.dart';
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
        appBar: AppBar(title: Text('Sad App')),
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
          padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text('Personal information'),
                  onPressed: con.personalRoute,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text('Patient history'),
                  onPressed: con.patientRoute,
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
                  onPressed: con.mitigationRoute,
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
  _UserHomeState state;
  _Controller(this.state);

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      //do nothing
    }
    Navigator.of(state.context).pop(); //Close app drawer
    Navigator.of(state.context).pop(); //Close home screen
  }

  void personalRoute() {
    //Navigator.pushNamed(state.context, PersonalInfoScreen.routeName);
  }
  void patientRoute() {
    //Navigator.pushNamed(state.context, PatientHistoryScreen.routeName);
  }
  void riskRoute() {
    //Navigator.pushNamed(state.context, RiskScreen.routeName);
  }
  void mitigationRoute() {
    //Navigator.pushNamed(state.context, MitigationScreen.routeName);
  }
}
