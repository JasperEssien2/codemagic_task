import 'package:codemagic_task/state_management/app_state.dart';
import 'package:codemagic_task/widgets/appbar.dart';
import 'package:flutter/material.dart';

import 'author_item.dart';

class AuthorsListScreen extends StatefulWidget {
  const AuthorsListScreen({Key? key}) : super(key: key);

  @override
  _AuthorsListScreenState createState() => _AuthorsListScreenState();
}

class _AuthorsListScreenState extends State<AuthorsListScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final authors = appState.logic.authorList;

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
        child: FutureBuilder(
          future: appState.logic.fetchAuthors(),
          builder: (c, state) => ListView.builder(
            itemCount: authors.length,
            padding: const EdgeInsets.symmetric(vertical: 24),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (c, index) => AuthorItem(
              author: authors[index],
            ),
          ),
        ),
      ),
    );
  }

  bool get _isLightMode => Theme.of(context).brightness == Brightness.light;
}
