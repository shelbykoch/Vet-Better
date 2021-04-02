import 'package:Capstone/Controller/notificationController.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/location.dart';
import 'package:Capstone/Model/medication.dart';
import 'package:Capstone/Model/notification_settings.dart';
import 'package:Capstone/Model/personal_Info.dart';
import 'package:Capstone/Screen/contact_list_screen.dart';
import 'package:Capstone/Model/question.dart';
import 'package:Capstone/Screen/dailyquestions_screen.dart';
import 'package:Capstone/Model/social_activity.dart';
import 'package:Capstone/Screen/Social%20Activities/socialActivity_screen.dart';
import 'package:Capstone/Screen/factor_screen.dart';
import 'package:Capstone/Screen/login_screen.dart';
import 'package:Capstone/Screen/myMedication_screen.dart';
import 'package:Capstone/Screen/notificationsettings_screen.dart';
import 'package:Capstone/Screen/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Controller/firebase_controller.dart';
import '../Model/constant.dart';
import 'calendar_screen.dart';
import 'factor_add_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  List<Question> questionList;
  List<NotificationSettings> settings;

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
    questionList ??= args[Constant.ARG_QUESTION_LIST];
    settings ??= args[Constant.ARG_NOTIFICATION_SETTINGS];
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
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Notification Settings'),
                onTap: con.notificationSettings,
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
  //This is the default button used on the every homescreen
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

  //This will build a button list based on the navbar index
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
        buttons.add(_screenButton(() => socialActRoute(),
            FaIcon(FontAwesomeIcons.users), "Social Activities"));
        buttons.add(_screenButton(() => reachOutRoute(),
            FaIcon(FontAwesomeIcons.comments), "Reach Out"));
        buttons.add(_screenButton(() => emergencyContactRoute(),
            FaIcon(FontAwesomeIcons.ambulance), "Emergency Contact"));
        break;
      case 2:
        buttons.add(_screenButton(() => calendarRoute(),
            FaIcon(FontAwesomeIcons.calendarAlt), "Appointments"));
        buttons.add(_screenButton(() => medicationInfoRoute(),
            FaIcon(FontAwesomeIcons.prescriptionBottleAlt), "Medications"));
        buttons.add(_screenButton(() => dailyQuestionsRoute(),
            FaIcon(FontAwesomeIcons.question), "Daily Questions"));
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

  void dailyQuestionsRoute() async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime newDay = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 00);
    if (newDay.isBefore(now)) {
      newDay = newDay.add(const Duration(minutes: 1));
    }
    _state.questionList =
        await FirebaseController.getQuestionList(_state.user.email);
    if (_state.questionList == null) {
      List<Question> questionList = new List<Question>();
      questionList = Question.getDailyQuestions(_state.user.email);
      for (Question question in questionList)
        await FirebaseController.addQuestionInfo(question);
      questionList =
          await FirebaseController.getQuestionList(_state.user.email);
      Navigator.pushNamed(_state.context, DailyQuestionsScreen.routeName,
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_QUESTION_LIST: questionList,
          });
    } else {
      Navigator.pushNamed(_state.context, DailyQuestionsScreen.routeName,
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_QUESTION_LIST: _state.questionList,
          });
    }
  }

  void socialActRoute() async {
    //Request data from database.
    //If Firebase doesn't find the collection then an new version is returned
    List<SocialActivity> socialActivities =
        await FirebaseController.getSocialActivityList(_state.user.email);
    List<Contact> contacts = await FirebaseController.getContactList(
        _state.user.email, ContactType.Social);
    List<Activity> activities =
        await FirebaseController.getActivityList(_state.user.email);
    List<Location> locations =
        await FirebaseController.getLocationList(_state.user.email);

    Navigator.pushNamed(_state.context, SocialActivityScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_SOCIALACTIVITIES: socialActivities,
          Constant.ARG_CONTACTS: contacts,
          Constant.ARG_ACTIVITIES: activities,
          Constant.ARG_LOCATIONS: locations,
        });
  }
  //------------------------APP TRAY ROUTING--------------------------//

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      //do nothing
    }
    // Navigator.of(_state.context).pop(); //Close app drawer
    // Navigator.of(_state.context).pop(); //Close home screen
    Navigator.pushReplacementNamed(_state.context, LoginScreen.routeName);
  }

  void notificationSettings() async {
    _state.settings =
        await FirebaseController.getNotificationSettings(_state.user.email);
    if (_state.settings == null) {
      List<NotificationSettings> settings = new List<NotificationSettings>();
      settings =
          NotificationSettings.getNotificationSettings(_state.user.email);
      for (NotificationSettings setting in settings)
        await FirebaseController.addNotificationSetting(setting);
      settings =
          await FirebaseController.getNotificationSettings(_state.user.email);
      Navigator.pushNamed(_state.context, NotificationSettingsScreen.routeName,
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_NOTIFICATION_SETTINGS: settings,
          });
    } else {
      for (int i = 0; i < _state.settings.length; i++) {
        print(
            "settings: ${_state.settings[i].notificationIndex} ${_state.settings[i].notificationTitle}, ${_state.settings[i].currentToggle}");
      }
      Navigator.pushNamed(_state.context, NotificationSettingsScreen.routeName,
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_NOTIFICATION_SETTINGS: _state.settings,
          });
    }
  }
}
