import 'package:codemagic_task/business_logic/app_state.dart';
import 'package:codemagic_task/presentation/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'author_item.dart';

class AuthorsListScreen extends StatefulWidget {
  const AuthorsListScreen({Key? key}) : super(key: key);

  @override
  _AuthorsListScreenState createState() => _AuthorsListScreenState();
}

class _AuthorsListScreenState extends State<AuthorsListScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      AppState.of(context).logic.fetchAuthors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final authors = appState.uiState.authors;

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
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authors != null)
                  Flexible(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: fetchNextPageData,
                      child: ListView.builder(
                        itemCount: authors.length,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (c, index) => AuthorItem(
                          author: authors[index],
                        ),
                      ),
                    ),
                  ),
                if (appState.uiState.isBottomLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12, right: 8, left: 8),
                    child: LinearProgressIndicator(minHeight: 6),
                  )
              ],
            ),
            if (appState.uiState.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  bool fetchNextPageData(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      AppState.of(context).logic.fetchAuthors();
      return true;
    }
    return false;
  }

  bool get _isLightMode => !AppState.of(context).uiState.darkMode;
}
