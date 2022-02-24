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
    Author(name: "Jahswill", image: '', description: 'My description'),
    Author(name: "Essien", image: '', description: 'My description'),
    Author(name: "Samuel", image: '', description: 'My description'),
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
