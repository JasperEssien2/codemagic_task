import 'package:codemagic_task/data/author_models.dart';

class AuthorService {
  final String authorUrl = "https://quotable.io/authors";

  Future<AuthorList> fetchAuthors() async {
    return AuthorList();
  }

  String authorImage(String id) => '';
}
