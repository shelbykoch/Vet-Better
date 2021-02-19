import 'package:flutter/material.dart';

class AppDialog {
  static void info({
    @required BuildContext context,
    @required String title,
    @required String message,
    @required Function action,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            RaisedButton(
              child: Text('OK', style: Theme.of(context).textTheme.button),
              onPressed: action,
            ),
          ],
        );
      },
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));
  }

  static void popProgressBar(BuildContext context) {
    Navigator.pop(context);
  }
}
