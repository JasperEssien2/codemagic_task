import 'dart:developer';

import 'package:codemagic_task/services/author_models.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

abstract class AuthorService {
  Future<Either<AuthorList, String>> fetchAuthors({int page = 1});
}

class AuthorServiceHttp implements AuthorService {
  AuthorServiceHttp({
    required this.authorUrl,
    required this.dioInstance,
  });

  final String authorUrl;
  final Dio dioInstance;

  @override
  Future<Either<AuthorList, String>> fetchAuthors({int page = 1}) async {
    try {
      final response = await dioInstance.get(
        authorUrl,
        queryParameters: {'page': page},
      );

      return Left(AuthorList.fromMap(response.data, authorImage));
    } catch (e) {
      log(e.toString());
      return const Right("An error occurred, please try again!");
    }
  }

  String authorImage(String slug) =>
      "https://images.quotable.dev/profile/400/$slug.jpg";
}
