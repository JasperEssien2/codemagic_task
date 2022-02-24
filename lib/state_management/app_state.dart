import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/services/author_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppState extends InheritedWidget {
  const AppState({
    Key? key,
    required this.isDarkMode,
    required this.authorList,
    required Widget child,
  }) : super(key: key, child: child);

  final bool isDarkMode;
  final List<Author> authorList;

  @override
  bool updateShouldNotify(covariant AppState oldWidget) =>
      !listEquals(oldWidget.authorList, authorList) &&
      oldWidget.isDarkMode != isDarkMode;

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();

    assert(result != null, 'No $AppState found in context');
    return result!;
  }
}

class AppRootWidget extends StatefulWidget {
  const AppRootWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  _AppRootWidgetState createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRootWidget> {
  final service = AuthorService();

  late bool isDarkMode;
  List<Author> authorList = [];
  int nextPageNumber = 1;
  bool hasMoreToFetch = true;

  @override
  void initState() {
    super.initState();
    isDarkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> fetchAuthors() async {
    if (hasMoreToFetch) {
      final response = await service.fetchAuthors(page: nextPageNumber);
      if (response.isRight) {
        _handleSuccess(response.right);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.left)));
      }
    }
  }

  void _handleSuccess(AuthorList response) {
    final authorListModel = response;
    setState(() {
      nextPageNumber = nextPageNumber + 1;
      hasMoreToFetch = nextPageNumber != authorListModel.totalPages;
      authorList.addAll(authorListModel.authors?.toList() ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      authorList: authorList,
      child: widget.child,
      isDarkMode: isDarkMode,
    );
  }
}
