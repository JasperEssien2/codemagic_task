import 'package:codemagic_task/data/author_models.dart';
import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  const AppState({
    Key? key,
    required this.isDarkMode,
    required this.authorList,
    required this.child,
  }) : super(key: key, child: child);

  final bool isDarkMode;
  final List<AuthorList> authorList;
  @override
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    throw UnimplementedError();
  }
}

class AppRootWidget extends StatefulWidget {
  const AppRootWidget({Key? key}) : super(key: key);

  @override
  _AppRootWidgetState createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRootWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
