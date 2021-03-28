import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/question.dart';
import 'package:Capstone/Screen/answer_screen.dart';
import 'package:Capstone/Screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DailyQuestionsScreen extends StatefulWidget {
  static const routeName = '/dailyQuestionsScreen';

  @override
  State<StatefulWidget> createState() {
    return _DailyQuestionsState();
  }
}

class _DailyQuestionsState extends State<DailyQuestionsScreen> {
  _Controller con;
  User user;
  //int randomNumber;
  // Question questionInfo;
  List<Question> questionList;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    render(() {});
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    questionList ??= args[Constant.ARG_QUESTION_LIST];
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Questions"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName,
              arguments: {Constant.ARG_USER: user}),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text("Please answer each questionList"),
              SizedBox(height: 20.0),
              questionList == null
                  ? Text("Page Error, Check back later.")
                  : Card(
                      color: Colors.grey[800],
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                                title:
                                    Text(questionList[index].questionContent),
                                onTap: () => con.answerScreenRoute(index),
                                trailing: Icon(Icons.arrow_forward),
                                subtitle: questionList[index].answer == null
                                    ? Text('enter your answer')
                                    : Text("${questionList[index].answer}"));
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _DailyQuestionsState _state;
  _Controller(this._state);

  void answerScreenRoute(int index) async {
    // First we will load the medication info associated with the account to pass to the screen
    // if it doesn't exist in the database we will created a new one and append
    // the email then pass to the screen
    List<Question> questionList =
        await FirebaseController.getQuestionList(_state.user.email);

    Navigator.pushNamed(_state.context, AnswerScreen.routeName, arguments: {
      Constant.ARG_USER: _state.user,
      Constant.ARG_QUESTION_INFO: questionList[index],
    });
  }
}

//  PaddedRaisedButton(
//   buttonText:
//       'Schedule notification to appear in 5 seconds based '
//       'on local time zone',
//   onPressed: () async {
//     await con._zonedScheduleNotification();
//   },
// ),

// Future<void> _zonedScheduleNotification() async {
//   await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Reminder',
//       'Take your pillz!',
//       tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
//       const NotificationDetails(
//           android: AndroidNotificationDetails('your channel id',
//               'your channel name', 'your channel description')),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);
// }
