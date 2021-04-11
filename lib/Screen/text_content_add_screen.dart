import 'package:Capstone/Controller/firebase_controller.dart';
import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Model/text_content.dart';
import 'package:Capstone/views/mydialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TextContentAddScreen extends StatefulWidget {
  static const routeName = '/TextContentAddScreen';
  @override
  State<StatefulWidget> createState() {
    return _TextContentAddState();
  }
}

class _TextContentAddState extends State<TextContentAddScreen> {
  _Controller con;
  User user;
  TextContent textContent;
  List<TextContent> textContentList;
  int index;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    user ??= arg[Constant.ARG_USER];
    textContent ??= arg[Constant.ARG_TEXT_CONTENT];
    textContentList ??= arg[Constant.ARG_TEXT_CONTENT_LIST];
    index ??= arg['index'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Content'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: con.save,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(
                    'Add things like words of affirmation, words of encouragement, web links, or quotes.'),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  initialValue: textContent != null ? textContent.title : "",
                  autocorrect: true,
                  validator: con.validatorTitle,
                  onSaved: con.onSavedTitle,
                ),
                TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Content',
                  ),
                  initialValue: textContent != null ? textContent.content : "",
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  validator: con.validatorContent,
                  onSaved: con.onSavedContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _TextContentAddState _state;
  _Controller(this._state);
  String title;
  String content;

  void save() async {
    if (!_state.formKey.currentState.validate()) {
      MyDialog.info(
        context: _state.context,
        title: 'Error',
        content: 'Validator',
      );
      return; //If invalid, return
    }
    _state.formKey.currentState.save();
    if (_state.textContent == null) {
      var c = TextContent(
        title: title,
        content: content,
        email: _state.user.email,
      );
      _state.textContentList.add(c);
      try {
        await FirebaseController.addTextContent(c);
      } catch (e) {
        MyDialog.info(
          context: _state.context,
          title: 'Error',
          content: e.message ?? e.toString(),
        );
      }
      Navigator.pop(_state.context);
    } else {
      _state.textContentList[_state.index].title = title;
      _state.textContentList[_state.index].content = content;

      _state.textContent.title = title;
      _state.textContent.content = content;
      try {
        await FirebaseController.updateTextContent(_state.textContent);
      } catch (e) {
        MyDialog.info(
          context: _state.context,
          title: 'Error',
          content: e.message ?? e.toString(),
        );
      }
      Navigator.pop(_state.context);
    }
  }

  String validatorContent(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  String validatorTitle(String value) {
    if (value == null || value.trim().length < 2) {
      return 'min 2 chars';
    } else {
      return null;
    }
  }

  void onSavedTitle(String value) {
    this.title = value;
  }

  void onSavedContent(String value) {
    this.content = value;
  }
}
