import 'package:flutter/cupertino.dart';

//класс для кастомной анимации перехода на экран
class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child, RouteSettings? settings})
      : super(
          pageBuilder: (contex, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 500),
          settings: settings,
        );
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(animation),
        child: child,
      );
}
