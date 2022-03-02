import 'package:codemagic_task/data/author_models.dart';
import 'package:codemagic_task/presentation/author_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

main() {
  final author = Author(
    slug: 'slug',
    name: "Jasper",
    description: "A good writer",
    bio: "This is my bio",
    image:
        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
  );

  testWidgets(
    "Ensure that author details set correctly",
    (tester) async {
      await _pumpAuthorDetailScreen(tester, author);

      final nameFinder = find.text("Jasper");
      final bioFinder = find.text("This is my bio");

      expect(nameFinder, findsOneWidget);

      expect(bioFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Ensure that Hero widget tag is author slug",
    (tester) async {
      await _pumpAuthorDetailScreen(tester, author);

      final heroFinder = find.byType(Hero);

      expect(heroFinder, findsOneWidget);

      expect((tester.firstWidget(heroFinder) as Hero).tag, "slug");
    },
  );

  testWidgets(
    "Ensure that Hero widget tag is author id when slug is null",
    (tester) async {
      final author = Author(
        id: 'author-id',
        name: "Jasper",
        description: "A good writer",
        image:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
      );

      await _pumpAuthorDetailScreen(tester, author);

      final heroFinder = find.byType(Hero);

      expect(heroFinder, findsOneWidget);
      expect((tester.firstWidget(heroFinder) as Hero).tag, "author-id");
    },
  );

  testWidgets(
    "Ensure that author image is set correctly found",
    (tester) async {
      await _pumpAuthorDetailScreen(tester, author);

      final containerFinder = find.byWidgetPredicate(_containerWithImageSet);

      expect(containerFinder, findsOneWidget);
    },
  );
}

bool _containerWithImageSet(Widget widget) =>
    widget is Container &&
    ((widget.decoration as BoxDecoration?)?.image?.image as NetworkImage?)
            ?.url ==
        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';

Future<void> _pumpAuthorDetailScreen(WidgetTester tester, Author author) async {
  await mockNetworkImagesFor(
    () async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            settings = settings.copyWith(arguments: author);
            return MaterialPageRoute(
              settings: settings,
              builder: (c) => const AuthorDetailScreen(),
            );
          },
        ),
      );
    },
  );
}
