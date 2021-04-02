import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/question.dart';
import 'package:Capstone/Screen/dailyquestions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnswerScreen extends StatefulWidget {
  static const routeName = '/answerScreen';

  @override
  State<StatefulWidget> createState() {
    return _AnswerState();
  }
}

class _AnswerState extends State<AnswerScreen> {
  _Controller con;
  User user;
  Question questionInfo;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    questionInfo ??= args[Constant.ARG_QUESTION_INFO];
    if (questionInfo == null) questionInfo = new Question();
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Answers"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: formKey,
              child: TextFormField(
                initialValue:
                    questionInfo.answer == null ? null : questionInfo.answer,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 10.0),
                  labelText: questionInfo.questionContent,
                  labelStyle: TextStyle(fontSize: 20.0),
                ),
                onSaved: con.saveAnswer,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  con.save();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _AnswerState _state;
  _Controller(this._state);
  int index;
  

  void save() async {
    if (!_state.formKey.currentState.validate()) return; //If invalid, return
    _state.formKey.currentState.save();
    _state.questionInfo.email = _state.user.email;
    try {
      if (_state.questionInfo.docId == null) {
        String docId =
            await FirebaseController.addQuestionInfo(_state.questionInfo);
        _state.questionInfo.docId = docId;
      } else {
            await FirebaseController.updateQuestionInfo(_state.questionInfo);
      }
      List<Question> questionList =
          await FirebaseController.getQuestionList(_state.user.email);

      Navigator.pushNamed(_state.context, DailyQuestionsScreen.routeName,
          arguments: {
            Constant.ARG_USER: _state.user,
            Constant.ARG_QUESTION_LIST: questionList,
          });
    } catch (e) {
      print(e);
    }
  }

  void saveAnswer(String value) {
    _state.questionInfo.answer = value;
  }
}
