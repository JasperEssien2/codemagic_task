import 'package:codemagic_task/business_logic/app_state.dart';
import 'package:codemagic_task/data/author_service.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockedDio extends Mock implements Dio {}

class MockedAuthorServiceHttp extends Mock implements AuthorServiceHttp {}

class MockedAppStateLogic extends Mock implements AppStateLogic {}
