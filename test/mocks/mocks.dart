import 'package:codemagic_task/data/author_service.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockedDio extends Mock implements Dio {}

class MockedAuthorServiceHttp extends Mock implements AuthorServiceHttp {}
