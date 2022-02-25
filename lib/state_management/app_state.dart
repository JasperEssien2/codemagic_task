import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/services/author_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

abstract class AppStateLogic {
  void toggleDarkMode();

  Future<void> fetchAuthors();
}

class AppState extends InheritedWidget {
  const AppState({
    Key? key,
    required this.logic,
    required Widget child,
    required this.uiState,
  }) : super(key: key, child: child);

  final AppStateLogic logic;
  final UiState uiState;

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return uiState != oldWidget.uiState;
  }

  static AppState of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppState>();

    assert(result != null, 'No $AppState found in context');
    return result!;
  }
}

class UiState {
  final bool isLoading;
  final bool isBottomLoading;
  final List<Author>? authors;
  final String? errorMessage;
  final bool darkMode;

  UiState({
    this.isLoading = false,
    this.isBottomLoading = false,
    this.authors,
    this.errorMessage,
    this.darkMode = true,
  });

  success(List<Author> authors) =>
      UiState(isLoading: false, isBottomLoading: false, authors: authors);

  error(String errorMessage) => UiState(
        errorMessage: errorMessage,
        isLoading: false,
        isBottomLoading: false,
        authors: [],
      );

  darkModeState() => copyWith(darkMode: !darkMode);

  bool get isLoadingState => isBottomLoading || isLoading;

  UiState copyWith({
    bool? isLoading,
    bool? isBottomLoading,
    List<Author>? authors,
    bool? darkMode,
  }) {
    return UiState(
      isLoading: isLoading ?? this.isLoading,
      isBottomLoading: isBottomLoading ?? this.isBottomLoading,
      authors: authors ?? this.authors,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UiState &&
        other.isLoading == isLoading &&
        other.isBottomLoading == isBottomLoading &&
        listEquals(other.authors, authors) &&
        other.errorMessage == errorMessage &&
        other.darkMode == darkMode;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        isBottomLoading.hashCode ^
        authors.hashCode ^
        errorMessage.hashCode ^
        darkMode.hashCode;
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
  final service = AuthorService(
      dioInstance: Dio(), authorUrl: "https://quotable.io/authors");

  UiState _uiState = UiState();

  int _nextPageNumber = 1;

  bool _hasMoreToFetch = true;

  void _updateUiState(UiState uiState) {
    setState(() {
      _uiState = uiState;
    });
  }

  @override
  void initState() {
    super.initState();
    _uiState = _uiState.copyWith(
      darkMode: SchedulerBinding.instance!.window.platformBrightness ==
          Brightness.dark,
    );
  }

  @override
  void toggleDarkMode() {
    _updateUiState(_uiState.darkModeState());
  }

  @override
  Future<void> fetchAuthors() async {
    if (_canFetchData) {
      _updateUiState(
        _uiState.copyWith(
          isLoading: _nextPageNumber <= 1,
          isBottomLoading: _nextPageNumber > 1,
        ),
      );

      final response = await service.fetchAuthors(page: _nextPageNumber);
      response.fold(
        (errorMessage) => _handleError(errorMessage),
        (right) => _handleSuccess(right),
      );
    }
  }

  bool get _canFetchData => _hasMoreToFetch && !_uiState.isLoadingState;

  void _handleSuccess(AuthorList response) {
    final cachedAuthors = _uiState.authors ?? [];
    cachedAuthors.addAll(response.authors ?? []);

    _nextPageNumber = _nextPageNumber + 1;
    _hasMoreToFetch = _nextPageNumber != response.totalPages;

    _updateUiState(_uiState.success(cachedAuthors));
  }

  void _handleError(String errorMessage) {
    _updateUiState(_uiState.error(errorMessage));
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      child: widget.child,
      logic: this,
      uiState: _uiState,
    );
  }
}
