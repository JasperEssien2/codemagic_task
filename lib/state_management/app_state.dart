import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/services/author_service.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class AppStateLogic {
  void toggleDarkMode();

  Future<void> fetchAuthors();

  bool get isLoading;

  bool get isBottomLoading;
}

class AppStateModel {
  final bool isDarkMode;

  final List<Author> authorList;

  AppStateModel({
    required this.isDarkMode,
    required this.authorList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppStateModel &&
        other.isDarkMode == isDarkMode &&
        listEquals(other.authorList, authorList);
  }

  @override
  int get hashCode => isDarkMode.hashCode ^ authorList.hashCode;
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
    return data != oldWidget.data;
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

  List<Author> authorList = [];

  int _nextPageNumber = 1;

  bool _hasMoreToFetch = true;

  bool _isLoadingState = false;

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
    if (_hasMoreToFetch && !_isLoadingState) {
      _isLoadingState = true;
      final response = await service.fetchAuthors(page: _nextPageNumber);
      if (response.isRight) {
        _handleSuccess(response.right);
      } else {
        _handleError(response);
      }
    }
  }

  void _handleSuccess(AuthorList response) {
    final authorListModel = response;
    setState(() {
      _nextPageNumber = _nextPageNumber + 1;
      _hasMoreToFetch = _nextPageNumber != authorListModel.totalPages;
      authorList.addAll(authorListModel.authors?.toList() ?? []);
      _isLoadingState = false;
    });
  }

  void _handleError(Either<String, AuthorList> response) {
    setState(() {
      _isLoadingState = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.left)),
    );
  }

  @override
  bool get isLoading => _isLoadingState && _nextPageNumber <= 1;

  @override
  bool get isBottomLoading => _isLoadingState && _nextPageNumber > 1;

  @override
  Widget build(BuildContext context) {
    return AppState(
      child: widget.child,
      logic: this,
      data: AppStateModel(
        authorList: List.from(authorList),
        isDarkMode: isDarkMode,
      ),
    );
  }
}
