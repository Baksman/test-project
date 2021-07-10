import 'package:flutter/material.dart';

showKeySnackbar(
    String title, GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) {
  SnackBar(
      content: Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 15,
    ),
  ));
  scaffoldMessengerKey.currentState.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState
      .showSnackBar(SnackBar(content: Text(title)));
}

showScaffoldSnackbar(String title, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
