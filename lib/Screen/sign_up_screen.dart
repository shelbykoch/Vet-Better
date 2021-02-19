//Sign up page view
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  _Controller con;
  BuildContext context;
  var formKey = GlobalKey<FormState>();
  //User user = User();

  SignUpScreenState() {
    con = _Controller(this);
  }

  void stateChange(Function fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0, right: 40.0, left: 40.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                //initialValue: user.email,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                validator: con.validateEmail,
                onSaved: con.saveEmail,
              ),
              TextFormField(
                //initialValue: user.password,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                validator: con.validatePassword,
                onSaved: con.savePassword,
              ),
              RaisedButton(
                child: Text('Create Account'),
                onPressed: con.createAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  SignUpScreenState state;

  _Controller(this.state);

  String validateEmail(String value) {
    if (value == null || !value.contains('.') || !value.contains('@'))
      return 'Enter a valid Email address';
    else
      return null;
  }

  void saveEmail(String value) {
    //state.user.email = value;
  }

  String validatePassword(String value) {
    if (value == "" || value.length < 6)
      return 'Enter a password';
    else
      return null;
  }

  void savePassword(String value) {
    //state.user.password = value;
  }

  void createAccount() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }

    state.formKey.currentState.save();
    /*
    //using email/password: sign up an account at Firebase
    try {
      state.user.uid = await Firebase.createAccount(
        email: state.user.email,
        password: state.user.password,
      );
    } catch (e) {
      AppDialog.info(
        context: state.context,
        title: 'Account creation failed!',
        message: e.message != null ? e.message : e.toString(),
        action: () => Navigator.pop(state.context),
      );
      return; //cease account creation
    }

    try {
      //create user profile
      Firebase.createProfile(state.user);
    } on Exception catch (e) {
      state.user.username = null;
    }

    AppDialog.info(
      context: state.context,
      title: 'Account creation successful!',
      message: 'Your accounted was successfully created with email/password',
      action: () => Navigator.pop(state.context),
    );
    */
    return;
  }
}
