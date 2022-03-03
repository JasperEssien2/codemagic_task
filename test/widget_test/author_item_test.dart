import 'package:codemagic_task/data/author_models.dart';
import 'package:codemagic_task/presentation/author_detail_screen.dart';
import 'package:codemagic_task/presentation/author_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

main() {
  final author = Author(
    slug: 'slug',
    name: "Jasper",
    description: "A good writer",
    image:
        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
  );

  testWidgets(
    "Ensure that author details set correctly",
    (tester) async {
      await _pumpAuthorItemWidget(tester, author);

      final nameFinder = find.text("Jasper");
      final descriptionFinder = find.text("A good writer");

      expect(nameFinder, findsOneWidget);

      expect(descriptionFinder, findsOneWidget);
    },
  );

  testWidgets(
    "Ensure that Hero widget tag is author slug",
    (tester) async {
      await _pumpAuthorItemWidget(tester, author);

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

      await _pumpAuthorItemWidget(tester, author);

      final heroFinder = find.byType(Hero);

      expect(heroFinder, findsOneWidget);
      expect((tester.firstWidget(heroFinder) as Hero).tag, "author-id");
    },
  );

  testWidgets(
    "Ensure that author image is set correctly found",
    (tester) async {
      await _pumpAuthorItemWidget(tester, author);

      final imageFinder = find.byType(CircleAvatar);

      expect(imageFinder, findsOneWidget);
      expect(
        (tester.firstWidget(imageFinder) as CircleAvatar).backgroundImage,
        const NetworkImage(
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
      );
    },
  );

  testWidgets(
    "Ensure that when list tile tapped, AuthorDetail screen is opened",
    (tester) async {
      await _pumpAuthorItemWidget(tester, author);

      final listTileFinder = find.byType(ListTile);

      await tester.tap(listTileFinder);
      await tester.pumpAndSettle();

      final detailScreenFinder = find.byType(AuthorDetailScreen);

      expect(detailScreenFinder, findsOneWidget);
    },
  );
}

Future<void> _pumpAuthorItemWidget(WidgetTester tester, Author author) async {
  await mockNetworkImagesFor(
    () async {
      await tester.pumpWidget(
        MaterialApp(
          home: AuthorItem(author: author),
          routes: {
            AuthorDetailScreen.screenName: (context) =>
                const AuthorDetailScreen()
          },
        ),
      );
    },
  );
}
