import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:project/datasources/local_data_source/local_database_service.dart';
import 'package:project/datasources/remote_data_source/remote_service.dart';
import 'remote_datasource.dart';

// class MockHttpClient extends Mock implements Dio {}

void main() {
  RemoteServiceImpl remoteServiceImpl;
  Dio dio = Dio();
  final dioAdapter = DioAdapter();
  dio.httpClientAdapter = dioAdapter;
  MockLocalStorage mockLocalStorage;
  LocalServiceImpl dataSource;

  setUp(() {
    mockLocalStorage = MockLocalStorage();

    mockLocalStorage = MockLocalStorage();
    dataSource = LocalServiceImpl(
      mockLocalStorage,
    );
    remoteServiceImpl = RemoteServiceImpl(dataSource);
  });

  void setUpMockHttpClientSuccess200() {
    when(dioAdapter.onGet(
      any,
    )).thenAnswer((_) async => Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL with number
       being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
