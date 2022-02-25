import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/services/author_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class AppStateLogic {
  bool get isDarkMode;

  List<Author> get authorList;

  void toggleDarkMode();

  Future<void> fetchAuthors();

  bool get isFetchingNextPage;
}

class AppState extends InheritedWidget {
  const AppState({
    Key? key,
    required this.logic,
    required Widget child,
  }) : super(key: key, child: child);

  final AppStateLogic logic;

  @override
  bool updateShouldNotify(covariant AppState oldWidget) {
    final logic = oldWidget.logic;

    return !listEquals(logic.authorList, oldWidget.logic.authorList) ||
        logic.isDarkMode != oldWidget.logic.isDarkMode;
  }

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

class _AppRootWidgetState extends State<AppRootWidget>
    implements AppStateLogic {
  final service = AuthorService();

  late bool _isDarkMode;

  final List<Author> _authorList = [];

  int _nextPageNumber = 1;

  bool _hasMoreToFetch = true;

  @override
  void initState() {
    super.initState();
    _isDarkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
  }

  @override
  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  bool get isDarkMode => _isDarkMode;

  @override
  Future<void> fetchAuthors() async {
    if (_hasMoreToFetch) {
      final response = await service.fetchAuthors(page: _nextPageNumber);
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
      _nextPageNumber = _nextPageNumber + 1;
      _hasMoreToFetch = _nextPageNumber != authorListModel.totalPages;
      _authorList.addAll(authorListModel.authors?.toList() ?? []);
    });
  }

  @override
  List<Author> get authorList => _authorList;

  @override
  bool get isFetchingNextPage => _nextPageNumber > 1;

  @override
  Widget build(BuildContext context) {
    return AppState(
      child: widget.child,
      logic: this,
    );
  }
}
