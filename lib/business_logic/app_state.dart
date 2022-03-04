import 'package:codemagic_task/data/author_models.dart';
import 'package:codemagic_task/data/author_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  success(List<Author> authors) => copyWith(
        isLoading: false,
        isBottomLoading: false,
        authors: authors,
        errorMessage: null,
      );

  error(String errorMessage) => copyWith(
        errorMessage: errorMessage,
        isLoading: false,
        isBottomLoading: false,
      );

  darkModeState() => copyWith(darkMode: !darkMode);

  bool get isLoadingState => isBottomLoading || isLoading;

  UiState copyWith({
    bool? isLoading,
    bool? isBottomLoading,
    List<Author>? authors,
    bool? darkMode,
    String? errorMessage,
  }) {
    return UiState(
      isLoading: isLoading ?? this.isLoading,
      isBottomLoading: isBottomLoading ?? this.isBottomLoading,
      authors: authors ?? this.authors,
      darkMode: darkMode ?? this.darkMode,
      errorMessage: errorMessage ?? this.errorMessage,
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

class AppRootWidget extends StatefulWidget {
  const AppRootWidget({
    Key? key,
    required this.child,
    required this.service,
  }) : super(key: key);

  final AuthorService service;
  final Widget child;

  @override
  _AppRootWidgetState createState() => _AppRootWidgetState();
}

class _AppRootWidgetState extends State<AppRootWidget>
    implements AppStateLogic {
  UiState _uiState = UiState();

  UiState get uiState => _uiState;

  int _nextPageNumber = 1;

  bool _hasMoreToFetch = true;

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

      final response = await widget.service.fetchAuthors(page: _nextPageNumber);
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

    _hasMoreToFetch = _nextPageNumber != response.totalPages;

    _nextPageNumber = _nextPageNumber + 1;

    _updateUiState(_uiState.success(cachedAuthors));
  }

  void _handleError(String errorMessage) {
    _updateUiState(_uiState.error(errorMessage));
  }

  void _updateUiState(UiState uiState) {
    setState(() {
      _uiState = uiState;
    });
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
