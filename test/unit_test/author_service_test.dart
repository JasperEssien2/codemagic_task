import 'package:codemagic_task/data/author_models.dart';
import 'package:codemagic_task/data/author_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/dio_mock.dart';

const dataJson = {
  "count": 20,
  "totalCount": 700,
  "page": 1,
  "totalPages": 35,
  "lastItemIndex": 20,
  "results": [
    {
      "link": "https://en.wikipedia.org/wiki/A._P._J._Abdul_Kalam",
      "bio":
          "Avul Pakir Jainulabdeen Abdul Kalam (15 October 1931 – 27 July 2015) was an aerospace scientist who served as the 11th President of India from 2002 to 2007.",
      "description": "Scientist and 11th President of India",
      "_id": "Bblz8Knp6-ZB",
      "name": "A. P. J. Abdul Kalam",
      "quoteCount": 2,
      "slug": "a-p-j-abdul-kalam",
      "dateAdded": "2019-12-13",
      "dateModified": "2019-12-13"
    }
  ]
};

main() {
  late MockedDio dio;
  late String url;
  late AuthorServiceHttp authorService;

  setUp(
    () {
      dio = MockedDio();
      url = "https://quotable.io/authors";
      authorService = AuthorServiceHttp(authorUrl: url, dioInstance: dio);
    },
  );

  group(
    "Test fetchAuthors()",
    () {
      group(
        "Test response",
        () {
          test(
            "Ensure that AuthorList is contained but string error throws an error "
            "when request is successful",
            () async {
              _mockSuccess(dio, url);

              var response = await authorService.fetchAuthors();

              expect(() => response.left, throwsException);
              expect(
                response.right,
                AuthorList.fromMap(
                    dataJson,
                    (_) =>
                        "https://images.quotable.dev/profile/400/a-p-j-abdul-kalam.jpg"),
              );
            },
          );

          test(
            "Ensure that AuthorList throws an exception but string error is contained "
            "when request fails",
            () async {
              _mockError(dio, url);

              var response = await authorService.fetchAuthors();

              expect(() => response.right, throwsException);
              expect(response.left, "An error occurred, please try again!");
            },
          );
        },
      );

      group(
        "Ensure correct dio.get() is called with correct parameters",
        () {
          test(
            "Ensure that correct url is passed and by default page is set to 1 ",
            () {
              _mockSuccess(dio, url);

              authorService.fetchAuthors();

              verify(() => dio.get(url, queryParameters: {'page': 1}));
            },
          );

           test(
            "Ensure that correct url is passed and page is set correctly ",
            () {
              _mockSuccess(dio, url);

              authorService.fetchAuthors(page: 5);

              verify(() => dio.get(url, queryParameters: {'page': 5}));
            },
          );
        },
      );
    },
  );

  group(
    "Test authorImage()",
    () {
      test(
        "Ensure that correct image url is returned when authorImage(slug) called",
        () {
          expect(authorService.authorImage('unique-slug'),
              "https://images.quotable.dev/profile/400/unique-slug.jpg");
        },
      );
    },
  );
}

void _mockSuccess(MockedDio dio, String url) {
  when(() => dio.get(url, queryParameters: any(named: 'queryParameters')))
      .thenAnswer(
    (_) => Future.value(
      Response(
        data: dataJson,
        requestOptions: RequestOptions(path: ''),
      ),
    ),
  );
}

void _mockError(MockedDio dio, String url) {
  when(() => dio.get(url, queryParameters: any(named: 'queryParameters')))
      .thenThrow(DioError(requestOptions: RequestOptions(path: '')));
}
