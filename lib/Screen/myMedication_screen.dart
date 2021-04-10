import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'editMed_screen.dart';

class MyMedicationScreen extends StatefulWidget {
  const MyMedicationScreen(
    this.payload, {
    Key key,
  }) : super(key: key);
  final String payload;
  static const routeName = '/myMedicationScreen';

  @override
  State<StatefulWidget> createState() {
    return _MyMedicationState();
  }
}

class _MyMedicationState extends State<MyMedicationScreen> {
  _Controller con;
  List<Medication> medication;
  User user;
  String _payload;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    _payload = widget.payload;
    print("payload myMedScreen: ${_payload}");
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    render(() {});
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    medication ??= args[Constant.ARG_MEDICATION_LIST];
    return Scaffold(
      appBar: AppBar(
        title: Text("My Medication"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (_payload == null) {
                print("push");
                Navigator.pushNamed(context, HomeScreen.routeName, arguments: {
                  Constant.ARG_USER: user,
                });
              } else {
                print("pop");
                Navigator.pop(context);
              }
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            medication == null
                ? Text('Add Medications to your list')
                : Card(
                    color: Colors.grey[800],
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: medication.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(medication[index].medName),
                            onTap: () => con.editMedicationInfoRoute(index),
                            trailing: Icon(Icons.arrow_forward),
                            subtitle: Text(
                                "${medication[index].doseAmt}mg, ${medication[index].timesDaily} times daily"),
                          );
                        }),
                  ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => con.addMedicationInfoRoute(),
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _MyMedicationState _state;
  _Controller(this._state);

  void editMedicationInfoRoute(int index) async {
    // First we will load the medication info associated with the account to pass to the screen
    // if it doesn't exist in the database we will created a new one and append
    // the email then pass to the screen
    List<Medication> medicationList =
        await FirebaseController.getMedicationList(_state.user.email);

    Navigator.pushNamed(_state.context, EditMedScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_MEDICATION_INFO: medicationList[index],
    });
  }

  void addMedicationInfoRoute() async {
    // First we will load the medication info associated with the account to pass to the screen
    // if it doesn't exist in the database we will created a new one and append
    // the email then pass to the screen
    // await FirebaseController.getMedicationList(_state.user.email);
    Navigator.pushNamed(_state.context, EditMedScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
    });
  }

  // Future<bool> navigateHome() {
  //   Navigator.pushNamed(_state.context, HomeScreen.routeName, arguments: {
  //     Constant.ARG_USER: _state.user,
  //   });
  // }
}
