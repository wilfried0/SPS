import 'package:flutter/material.dart';

class SlideFromTopRoute extends PageRouteBuilder {
  Widget widget;
  SlideFromTopRoute({this.widget}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder : (context, animation, secondaryAnimation, child){
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 1.0),
        ).animate(secondaryAnimation),
        child: child,
      );
  }
  );
}