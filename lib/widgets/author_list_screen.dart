import 'dart:developer';

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
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (_hasReachedBottomOfList) {
          AppState.of(context).logic.fetchAuthors();
          log("HAS REACHED END OF LIST ================");
        }
      },
    );
  }

  bool get _hasReachedBottomOfList {
    return scrollController.position.pixels ==
        scrollController.position.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final authors = appState.data.authorList;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppbar(
          title: "Hi Jahswill 👋",
          actions: [
            InkWell(
              onTap: appState.logic.toggleDarkMode,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: Icon(_isLightMode ? Icons.dark_mode : Icons.light_mode),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: appState.logic.fetchAuthors(),
          builder: (c, state) =>
              state.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: authors.length,
                      controller: scrollController,
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

  bool get _isLightMode => !AppState.of(context).data.isDarkMode;
}
