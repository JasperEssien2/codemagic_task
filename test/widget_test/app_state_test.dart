import 'package:codemagic_task/business_logic/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mocks.dart';

main() {
  group(
    "Test updateShouldNotify()",
    () {
      testWidgets(
        "Ensure that updateShouldNotify() returns true when UiState is "
        "different from old UiState",
        (tester) async {
          await _pumpAppState(tester);

          final appStateFinder = find.byType(AppState);

          expect(
            (tester.firstWidget(appStateFinder) as AppState).updateShouldNotify(
              _appState(
                uiState: UiState(),
              ),
            ),
            true,
          );
        },
      );

      testWidgets(
        "Ensure that updateShouldNotify() returns false when UiState is "
        "the same with old UiState",
        (tester) async {
          await _pumpAppState(tester);

          final appStateFinder = find.byType(AppState);

          expect(
            (tester.firstWidget(appStateFinder) as AppState).updateShouldNotify(
              _appState(),
            ),
            false,
          );
        },
      );
    },
  );

  group(
    "Test AppState.of()",
    () {
      testWidgets(
        "Ensure that an instance of AppState is returned when AppState is in widget tree",
        (tester) async {
          await _pumpAppState(tester);

          final BuildContext context = tester.element(find.byType(MaterialApp));

          expect(AppState.of(context), isA<AppState>());
        },
      );

      testWidgets(
        "Ensure that an Assertion is thrown when instance of AppState is NOT FOUND in widget tree",
        (tester) async {
          await tester.pumpWidget(const MaterialApp());

          final BuildContext context = tester.element(find.byType(MaterialApp));

          expect(() => AppState.of(context), throwsAssertionError);
        },
      );
    },
  );
}

Future<void> _pumpAppState(WidgetTester tester) async {
  await tester.pumpWidget(_appState(
    child: const MaterialApp(),
  ));
}

AppState _appState({Widget? child, UiState? uiState}) {
  return AppState(
    logic: MockedAppStateLogic(),
    uiState: uiState ?? UiState(darkMode: true, isLoading: true),
    child: child ?? const SizedBox.shrink(),
  );
}
