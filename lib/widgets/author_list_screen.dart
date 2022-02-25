import 'package:codemagic_task/state_management/app_state.dart';
import 'package:codemagic_task/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      AppState.of(context).logic.fetchAuthors();
    });

    scrollController.addListener(
      () {
        if (_hasReachedBottomOfList) {
          AppState.of(context).logic.fetchAuthors();
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
            ListView.separated(
              itemCount: authors!.length,
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 24),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (c, index) => AuthorItem(
                author: authors[index],
              ),
              separatorBuilder: (c, index) {
                if (index == authors.length - 1 &&
                    appState.uiState.isBottomLoading) {
                  return const LinearProgressIndicator(minHeight: 6);
                }
                return const SizedBox.shrink();
              },
            ),
            if (appState.uiState.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  bool get _isLightMode => !AppState.of(context).uiState.darkMode;
}
