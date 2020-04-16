import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SysSnackBar {
  show(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message, textAlign: TextAlign.center,)));
  }

  void error(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Impossible de traiter votre requête !', textAlign: TextAlign.center,)));
  }
}
