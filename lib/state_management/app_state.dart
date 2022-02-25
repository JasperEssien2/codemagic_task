import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/services/author_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class AppStateLogic {
  void toggleDarkMode();

  Future<void> fetchAuthors();

  bool get isFetchingNextPage;
}

class AppStateModel {
  final bool isDarkMode;

  final List<Author> authorList;

  AppStateModel({
    required this.isDarkMode,
    required this.authorList,
  });
}

class AppState extends InheritedWidget {
  const AppState({
    Key? key,
    required this.logic,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  final AppStateLogic logic;
  final AppStateModel data;

  @override
  bool updateShouldNotify(AppState oldWidget) {
    final oldData = oldWidget.data;

    return !listEquals(data.authorList, oldData.authorList) ||
        data.isDarkMode != oldData.isDarkMode;
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

class _AppRootWidgetState extends State<AppRootWidget> with AppStateLogic {
  final service = AuthorService();

  bool isDarkMode = false;

  final List<Author> authorList = [];

  int _nextPageNumber = 1;

  bool _hasMoreToFetch = true;

  @override
  void initState() {
    super.initState();
    isDarkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
  }

  @override
  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

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
      authorList.addAll(authorListModel.authors?.toList() ?? []);
    });
  }

  @override
  bool get isFetchingNextPage => _nextPageNumber > 1;

  @override
  Widget build(BuildContext context) {
    return AppState(
      child: widget.child,
      logic: this,
      data: AppStateModel(
        authorList: authorList,
        isDarkMode: isDarkMode,
      ),
    );
  }
}
