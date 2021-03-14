import 'package:flutter/material.dart';
import '../Controller/firebase_controller.dart';
import 'app_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPasswordScreen';
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  _Controller con;
  BuildContext context;
  var formKey = GlobalKey<FormState>();

  _ForgotPasswordScreenState() {
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot password'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
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
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text('Send password reset'),
                      onPressed: con.resetPassword,
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
  _ForgotPasswordScreenState state;
  _Controller(this.state);
  String email;

  String validateEmail(String value) {
    if (value == null || !value.contains('.') || !value.contains('@'))
      return 'Enter a valid email address';
    else
      return null;
  }

  void saveEmail(String value) {
    email = value;
  }

  void resetPassword() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();

    try {
      await FirebaseController.resetPassword(email.trim());
      AppDialog.info(
        context: state.context,
        title: 'Password Reset',
        message: 'A link to reset your password has been sent to your email.',
        action: () =>
            {Navigator.pop(state.context), Navigator.pop(state.context)},
      );
    } catch (e) {
      AppDialog.info(
          context: state.context,
          title: 'Error',
          message: e.message ?? e.toString(),
          action: () => {Navigator.pop(state.context)});
    }
  }
}
