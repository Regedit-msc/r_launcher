import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({
    @required this.child,
  }) : super(
            reverseTransitionDuration: Duration(milliseconds: 500),
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation myAnim = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
    Animation<double> myCurve = CurvedAnimation(
        parent: myAnim, curve: Curves.easeIn, reverseCurve: Curves.easeOut);
    return FadeTransition(opacity: myCurve, child: child);
  }
}
