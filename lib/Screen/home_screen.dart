import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Screen/contact_edit_screen.dart';
import 'package:Capstone/Screen/contact_list_screen.dart';
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
    con._buildButtonList();
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
        body: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            padding: EdgeInsets.only(left: 40, right: 40, top: 20),
            children: con._buildButtonList()),
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

//-----------------------GRID & BUTTON BUILDER-----------------------//
  Widget _screenButton(Function route, FaIcon icon, String text) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      //width: double.infinity,
      child: RaisedButton(
        onPressed: route,
        child: Column(
          // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 45.0),
              child: icon,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0), child: Text(text)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtonList() {
    List<Widget> buttons = new List<Widget>();
    buttons.clear();
    switch (_state._navIndex) {
      case 0:
        buttons.add(_screenButton(
            () => factorRoute(ListType.MedicalHistory, "Medical History"),
            FaIcon(FontAwesomeIcons.userMd),
            "Medical History"));
        buttons.add(_screenButton(
            () => factorRoute(ListType.PsychHistory, "Psychiatric History"),
            FaIcon(FontAwesomeIcons.brain),
            "Psychiatric History"));
        buttons.add(_screenButton(
            () => factorRoute(ListType.RiskFactors, "Risk Factors"),
            FaIcon(FontAwesomeIcons.chartBar),
            "Risk Factors"));
        buttons.add(_screenButton(
            () => factorRoute(ListType.MitigationFactors, "Mitigation Factors"),
            FaIcon(FontAwesomeIcons.projectDiagram),
            "Mitigation Factors"));
        buttons.add(_screenButton(
            () => factorRoute(ListType.WarningSigns, "Warning Signs"),
            FaIcon(FontAwesomeIcons.exclamationTriangle),
            "Warning Signs"));
        buttons.add(_screenButton(
            () => factorRoute(ListType.CopingStrategies, "Coping Strategies"),
            FaIcon(FontAwesomeIcons.hiking),
            "Coping Strategies"));
        break;
      case 1:
        buttons.add(_screenButton(
            () => {}, FaIcon(FontAwesomeIcons.users), "Social Activities"));
        buttons.add(_screenButton(() => reachOutRoute(),
            FaIcon(FontAwesomeIcons.comments), "Reach Out"));
        buttons.add(_screenButton(() => emergencyContactRoute(),
            FaIcon(FontAwesomeIcons.ambulance), "Emergency Contact"));
        break;
      case 2:
        buttons.add(_screenButton(() => calendarRoute(),
            FaIcon(FontAwesomeIcons.calendarAlt), "Appointments"));
        buttons.add(_screenButton(() => {},
            FaIcon(FontAwesomeIcons.prescriptionBottleAlt), "Medications"));
        break;
      case 3:
        buttons.add(Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
          child: ListView(children: <Widget>[Text('Feel good vault')]),
        ));
    }
    return buttons;
  }

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

  void contactEditRoute() async {
    Contact contact =
        new Contact.withEmail(_state.user.email, ContactType.Personal);
    contact.type = ContactType.Personal;
    await Navigator.pushNamed(_state.context, ContactEditScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_CONTACT: contact,
        });
  }

  void reachOutRoute() async {
    List<Contact> contacts = await FirebaseController.getContactList(
        _state.user.email, ContactType.Personal);

    Navigator.pushNamed(_state.context, ContactListScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_CONTACT_LIST: contacts,
          Constant.ARG_CONTACT_TYPE: ContactType.Personal,
          Constant.ARG_CONTACT_TITLE: 'Reach out',
        });
  }

  void emergencyContactRoute() async {
    List<Contact> contacts = await FirebaseController.getContactList(
        _state.user.email, ContactType.Emergency);

    Navigator.pushNamed(_state.context, ContactListScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_CONTACT_LIST: contacts,
          Constant.ARG_CONTACT_TYPE: ContactType.Emergency,
          Constant.ARG_CONTACT_TITLE: 'Emergency contacts',
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
