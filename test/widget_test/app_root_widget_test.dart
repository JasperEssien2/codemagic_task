import 'package:codemagic_task/business_logic/app_state.dart';
import 'package:codemagic_task/data/author_models.dart';
import 'package:codemagic_task/data/author_service.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mocks.dart';

main() {
  late MockedAuthorServiceHttp authorService;
  final childWidget = Container();
  setUp(
    () {
      authorService = MockedAuthorServiceHttp();
    },
  );

  group(
    "Test toggleMode()",
    () {
      testWidgets(
        "Ensure that by default dark mode enabled",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          expect(state.uiState, UiState(darkMode: true));
        },
      );

      testWidgets(
        "Ensure that dark mode is false when toggleDarkMode() called",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          state.toggleDarkMode();

          expect(state.uiState, UiState(darkMode: false));
        },
      );
    },
  );
  group(
    "Test fetchAuthors() loading states",
    () {
      testWidgets(
        "Ensure that isLooading is false and isBottomLoading is true when page to fetch is greater equal to 1 ",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          state.fetchAuthors().ignore();

          expect(
            state.uiState,
            UiState(isLoading: true),
          );

          verify(() => authorService.fetchAuthors());
        },
      );

      testWidgets(
        "Ensure that isLoading is false and isBottomLoading is true when page to fetch is greater than 1, ",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          _mockSuccessAction(authorService);

          await state.fetchAuthors();
          state.fetchAuthors().ignore();

          expect(
            state.uiState,
            UiState(isBottomLoading: true, authors: []),
          );
          verify(() => authorService.fetchAuthors());

          verify(() => authorService.fetchAuthors(page: 2));
        },
      );
    },
  );

  group(
    "Test fetchAuthors() response",
    () {
      testWidgets(
        "Ensure that UiState author list is inserted when fetching initial page  and request is successful",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          _mockSuccessAction(
            authorService,
            authorList: AuthorList(authors: [Author(id: 'id1')]),
          );

          await state.fetchAuthors();

          expect(
            state.uiState,
            UiState(
              authors: [Author(id: 'id1')],
            ),
          );

          verify(() => authorService.fetchAuthors());
        },
      );

      testWidgets(
        "Ensure that UiState author list is updated and not replaced when fetching next data page and request is successful",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          await _performFetchTwiceAction(authorService, state);

          expect(
            state.uiState,
            UiState(
              authors: [Author(id: 'id1'), Author(id: 'id2')],
            ),
          );

          verify(() => authorService.fetchAuthors());

          verify(() => authorService.fetchAuthors(page: 2));
        },
      );

      testWidgets(
        "Ensure that UiState has error when request fails",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          _mockErrorAction(
              authorService, "An error occurred, please try again!");

          await state.fetchAuthors();

          expect(
            state.uiState,
            UiState(errorMessage: "An error occurred, please try again!"),
          );

          verify(() => authorService.fetchAuthors());
        },
      );
    },
  );

  group(
    "Test canFetchData",
    () {
      testWidgets(
        "Ensure that when isLoading is true, no request is made",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          state.fetchAuthors().ignore();

          _mockSuccessAction(authorService, page: 2);

          await state.fetchAuthors();

          verifyNever(() => authorService.fetchAuthors(page: 2));
        },
      );

      testWidgets(
        "Ensure that when isBottomLoading is true, no request is made",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          _mockSuccessAction(authorService);

          await state.fetchAuthors();

          _mockSuccessAction(authorService, page: 2);

          state.fetchAuthors().ignore();

          _mockSuccessAction(authorService, page: 3);
          await state.fetchAuthors();

          verifyNever(() => authorService.fetchAuthors(page: 3));
        },
      );

      testWidgets(
        "Ensure that when page has reached the end, request cannot be made",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          _mockSuccessAction(authorService,
              authorList: AuthorList(totalPages: 1));

          await state.fetchAuthors();

          _mockSuccessAction(authorService, page: 2);

          await state.fetchAuthors();

          verifyNever(() => authorService.fetchAuthors(page: 2));
        },
      );

      testWidgets(
        "Ensure that request is made, when not loading and page is not at limit",
        (tester) async {
          AppRootWidgetState state =
              await _pumpAndReturnState(tester, childWidget, authorService);

          _mockSuccessAction(authorService, authorList: AuthorList());

          await state.fetchAuthors();

          verify(() => authorService.fetchAuthors(page: 1));
        },
      );
    },
  );
}

Future<void> _performFetchTwiceAction(
    MockedAuthorServiceHttp authorService, AppRootWidgetState state) async {
  _mockSuccessAction(
    authorService,
    authorList: AuthorList(
      authors: [Author(id: 'id1')],
    ),
  );

  await state.fetchAuthors();

  _mockSuccessAction(
    authorService,
    page: 2,
    authorList: AuthorList(authors: [Author(id: 'id2')]),
  );

  await state.fetchAuthors();
}

void _mockSuccessAction(MockedAuthorServiceHttp authorService,
    {AuthorList? authorList, int page = 1}) {
  when(() => authorService.fetchAuthors(page: page)).thenAnswer(
    (_) => Future.value(
      Right(authorList ?? AuthorList()),
    ),
  );
}

void _mockErrorAction(MockedAuthorServiceHttp authorService, String error) {
  when(() => authorService.fetchAuthors()).thenAnswer(
    (_) => Future.value(
      Left(error),
    ),
  );
}

Future<AppRootWidgetState> _pumpAndReturnState(
  WidgetTester tester,
  Container childWidget,
  AuthorService authorService,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: AppRootWidget(
        child: childWidget,
        service: authorService,
      ),
    ),
  );

  final state = tester.state(find.byType(AppRootWidget)) as AppRootWidgetState;
  return state;
}
