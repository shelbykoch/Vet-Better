import 'package:Capstone/Controller/notificationController.dart';
import 'package:Capstone/Model/activity.dart';
import 'package:Capstone/Model/appointment.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/contact.dart';
import 'package:Capstone/Model/factor.dart';
import 'package:Capstone/Model/factor_score_calculator.dart';
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
import 'package:Capstone/Screen/factor_score_screen.dart';
import 'package:Capstone/Screen/login_screen.dart';
import 'package:Capstone/Screen/myMedication_screen.dart';
import 'package:Capstone/Screen/notificationsettings_screen.dart';
import 'package:Capstone/Screen/personal_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Controller/firebase_controller.dart';
import '../Model/constant.dart';
import '../Model/picture.dart';
import '../Model/text_content.dart';
import 'calendar_screen.dart';
import 'factor_add_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'picture_add_screen.dart';
import 'text_content_add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.payload, {
    Key key,
  }) : super(key: key);

  final String payload;
  static const routeName = '/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<HomeScreen> {
  _Controller con;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  String _payload;
  int _navIndex = 0;
  List<Question> questionList;
  List<NotificationSettings> settings;
  List<TextContent> textContentList;
  List<Picture> pictureList;
  int factorScore = 0;

  @override
  void initState() {
    super.initState();
    //final User user = auth.currentUser;
    con = _Controller(this);
    con._buildButtonList();
    _payload = widget.payload;
    if (_payload != 'new payload') {
      print('new payload');
      con.notificationRoute(_payload);
    }
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    questionList ??= args[Constant.ARG_QUESTION_LIST];
    settings ??= args[Constant.ARG_NOTIFICATION_SETTINGS];
    pictureList ??= args[Constant.ARG_PICTURE_LIST];
    textContentList ??= args[Constant.ARG_TEXT_CONTENT_LIST];
    return WillPopScope(
      onWillPop: () => Future.value(false), //Disable android system back button
      child: Scaffold(
        appBar: con._buildAppBar(),
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
              ListTile(
                leading: Icon(Icons.format_list_numbered_sharp),
                title: Text('Factor Scores'),
                onTap: con.factorScoreRoute,
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

  Widget _textContentButton(Function route, TextContent content) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      //width: double.infinity,
      child: RaisedButton(
        onPressed: route,
        child: Column(
          // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: FaIcon(FontAwesomeIcons.pencilAlt),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(content.title, overflow: TextOverflow.fade)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pictureButton(Function route, Picture picture) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      child: Expanded(
        child: InkWell(
          onTap: route,
          child: Image.network(picture.photoURL, fit: BoxFit.cover),
        ),
      ),
    );
  }

  //This will build a button list based on the navbar index
  List<Widget> _buildButtonList() {
    List<Widget> buttons = new List<Widget>();
    buttons.clear();
    _buildAppBar();
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
        _state.pictureList.forEach((p) {
          buttons.add(_pictureButton(() => vaultPictureRoute(p), p));
        });
        _state.textContentList.forEach((t) {
          buttons.add(_textContentButton(() => vaultContentRoute(t), t));
        });
        if (buttons.length == 0)
          buttons.add(Text(
              "Use the button in the app bar to add items to your vault!"));
        break;
      /*
        buttons.add(_screenButton(() => vaultContentRoute(),
            FaIcon(FontAwesomeIcons.notesMedical), "Add Text Content"));
        buttons.add(_screenButton(() => vaultPictureRoute(),
            FaIcon(FontAwesomeIcons.photoVideo), "Add Picture"));
    }
    return buttons;
  }

  AppBar _buildAppBar() {
    switch (_state._navIndex) {
      case 0:
      case 1:
      case 2:
        return AppBar(title: Text('Vet Better'));
      case 3:
        return AppBar(
          title: Text('Vet Better'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: addToVault,
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'picture',
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.photo),
                      Text('Picture'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'text',
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.edit),
                      Text('Text'),
                    ],
                  ),
                )
              ],
            )
          ],
        );
    }
  }

//------------------------HOME SCREEN ROUTING---------------------------//
  void vaultContentRoute(TextContent textContent) async {
    //Request content from database.
    //If Firebase doesn't find the collection then an new version is returned
    //List<TextContent> textContent =
    //  await FirebaseController.getTextContentList(_state.user.email);
    Navigator.pushNamed(_state.context, TextContentAddScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_TEXT_CONTENT: textContent,
        });
  }

  void vaultPictureRoute(Picture p) async {
    //Request pics from database.
    //If Firebase doesn't find the collection then an new version is returned
    //List<Picture> pictures =
       // await FirebaseController.getPictures(_state.user.email);
    Navigator.pushNamed(_state.context, PictureAddScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_PICTURE: p,
    });
  }

  void addToVault(String src) {
    if (src == 'picture') {
      Picture p = Picture.withEmail(_state.user.email);
      vaultPictureRoute(p);
    } else {
      TextContent t = TextContent.withEmail(_state.user.email);
      vaultContentRoute(t);
    }
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
    final user = _state.auth.currentUser;
    if (user != null) {
      List<Appointment> appointments =
          await FirebaseController.getAppointmentList(user.email);

    Navigator.pushNamed(_state.context, CalendarScreen.routeName, arguments: {
      Constant.ARG_USER: user,
      Constant.ARG_APPOINTMENTS: appointments,
    });
    }
  }

  void medicationInfoRoute() async {
    //First we will load the medication info associated with the account to pass to the screen
    //if it doesn't exist in the database we will created a new one and append
    //the email then pass to the screen
    final user = _state.auth.currentUser;
    if (user != null) {
      List<Medication> medication =
          await FirebaseController.getMedicationList(user.email);

      Navigator.pushNamed(_state.context, MyMedicationScreen.routeName,
          arguments: {
            Constant.ARG_USER: user,
            Constant.ARG_MEDICATION_LIST: medication,
          });
    }
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
    _state._payload = null;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    if (user != null)
      print("user: ${user.email}");
    else {
      print("user is null");
      print("_state.user: ${_state.user}");
    }
    _state.questionList = await FirebaseController.getQuestionList(user.email);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime newDay = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, now.hour, now.minute, 30);

    if (newDay.isAfter(now)) {
      if (_state.questionList != null) {
        for (Question q in _state.questionList)
          FirebaseController.deleteQuestion(q.docId);
      }
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
  void notificationRoute(payload) {
    print('payload notificationRoute: ${payload}');
    if (payload == 'daily questions') dailyQuestionsRoute();
    if (payload == 'medication') {
      //count++;
      medicationInfoRoute();
    }
    if (payload == 'appointment') calendarRoute();
    if (payload == 'new payload') return;
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
    Navigator.of(_state.context).pop(); //Close app drawer
    Navigator.of(_state.context).pop(); //Close home screen
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

  void factorScoreRoute() async {
    FactorScoreCalculator calculator = FactorScoreCalculator();
    Map<ListType, int> scoreMap =
        await calculator.getScoreMap(_state.user.email);
    int totalScore = await calculator.getTotalScore(_state.user.email);
    Navigator.pushNamed(_state.context, FactorScoreScreen.routeName,
        arguments: {
          Constant.ARG_USER: _state.user,
          Constant.ARG_FACTOR_SCORE_MAP: scoreMap,
          Constant.ARG_FACTOR_SCORE_TOTAL: totalScore,
        });
  }
}
