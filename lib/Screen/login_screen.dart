import 'package:Capstone/Model/constant.dart';
import 'package:Capstone/Screen/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controller/firebase_controller.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';
import 'app_dialog.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  _Controller con;
  BuildContext context;
  var formKey = GlobalKey<FormState>();

  _LoginScreenState() {
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.people, color: Colors.white),
            label: Text(
              'Create Account',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: con.createAccount,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  'The Sad App',
                  style: TextStyle(fontFamily: 'FiraCode', fontSize: 50.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
              child: Column(
                children: [
                  TextFormField(
                    //initialValue: user.email,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: con.validateEmail,
                    onSaved: con.saveEmail,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: con.validatePassword,
                    onSaved: con.savePassword,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text('Login'),
                      onPressed: con.login,
                    ),
                  ),
                  FlatButton(
                    onPressed: con.resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _LoginScreenState state;
  _Controller(this.state);
  String email;
  String password;

  void createAccount() {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        ));
  }

  String validateEmail(String value) {
    if (value == null || !value.contains('.') || !value.contains('@'))
      return 'Enter a valid email address';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value == "" || value.length <= 6)
      return 'Enter a password';
    else
      return null;
  }

  void saveEmail(String value) {
    email = value;
  }

  void savePassword(String value) {
    password = value;
  }

  void login() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();
    AppDialog.showProgressBar(state.context);

    User user;
    try {
      user = await FirebaseController.login(email: email, password: password);
    } catch (e) {
      AppDialog.popProgressBar(state.context);
      AppDialog.info(
        context: state.context,
        title: 'Login failed',
        message: e.message != null ? e.message : e.toString(),
        action: () => Navigator.pop(state.context),
      );
      return; //cease login process
    }

    Navigator.pop(state.context); //dispose dialog
    Navigator.pushNamed(state.context, HomeScreen.routeName,
        arguments: {Constant.ARG_USER: user});
  }

  void resetPassword() async {
    Navigator.pushNamed(state.context, ForgotPasswordScreen.routeName);
  }
}
