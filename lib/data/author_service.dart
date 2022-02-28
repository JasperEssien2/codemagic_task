import 'package:codemagic_task/data/author_models.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

abstract class AuthorService {
  Future<Either<String, AuthorList>> fetchAuthors({int page = 1});
}

class AuthorServiceHttp implements AuthorService {
  AuthorServiceHttp({
    required this.authorUrl,
    required this.dioInstance,
  });

  final String authorUrl;
  final Dio dioInstance;

  @override
  Future<Either<String, AuthorList>> fetchAuthors({int page = 1}) async {
    try {
      final response = await dioInstance.get(
        authorUrl,
        queryParameters: {'page': page},
      );

      return Right(AuthorList.fromMap(response.data, authorImage));
    } catch (e) {
      return const Left("An error occurred, please try again!");
    }
  }

  String authorImage(String slug) =>
      "https://images.quotable.dev/profile/400/$slug.jpg";
}
