import 'package:codemagic_task/services/author_models.dart';
import 'package:codemagic_task/widgets/appbar.dart';
import 'package:flutter/material.dart';

import 'author_item.dart';

class AuthorsListScreen extends StatefulWidget {
  const AuthorsListScreen({Key? key}) : super(key: key);

  @override
  _AuthorsListScreenState createState() => _AuthorsListScreenState();
}

class _AuthorsListScreenState extends State<AuthorsListScreen> {
  final authors = [
    Author(
      slug: 'slug1',
      image:
          "https://www.gannett-cdn.com/media/USATODAY/USATODAY/2013/03/22/ap-obit-achebe-16_9.jpg?width=2164&height=1223&fit=crop&format=pjpg&auto=webp",
      name: "Jasper Essien",
      description: "A description",
      bio: """What is Lorem Ipsum?
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
      """,
    ),
    Author(
      name: "Essien",
      image: '',
      description: 'My description',
      slug: 'slug2',
      bio: "A very short bio",
    ),
    Author(
      name: "Samuel",
      image: '',
      description: 'My description',
      slug: 'slug3',
      bio: "A very very short bio",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: "Hi Jahswill 👋",
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 16),
              child: Icon(_isLightMode ? Icons.dark_mode : Icons.light_mode),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: authors.length,
          padding: const EdgeInsets.symmetric(vertical: 24),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (c, index) => AuthorItem(
            author: authors[index],
          ),
        ),
      ),
    );
  }

  bool get _isLightMode => Theme.of(context).brightness == Brightness.light;
}
