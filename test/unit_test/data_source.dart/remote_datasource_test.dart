import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:mockito/mockito.dart' as mock;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project/datasources/local_data_source/local_database_service.dart';
import 'package:project/datasources/remote_data_source/remote_service.dart';
import 'package:project/datasources/source_response/failure.dart';
import 'package:project/models/item.dart';
import '../fixture/number_reaader.dart';
import 'local_datasource_test.dart';

class MockDio extends mock.Mock implements dio.Dio {}

void main() async {
  RemoteServiceImpl remoteServiceImpl;
  MockDio mockDio;
  MockLocalStorage mockLocalStorage;
  LocalServiceImpl dataSource;
  final failureMessage = "Not found";
  final url = "https://jsonplaceholder.typicode.com/posts";
  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockDio = MockDio();
    mockLocalStorage = MockLocalStorage();
    dataSource = LocalServiceImpl(
      mockLocalStorage,
    );
    remoteServiceImpl = RemoteServiceImpl(dataSource, mockDio);
  });

  void setUpMockHttpClientSuccess200() async {
    mock.when(mockDio.get(any)).thenAnswer((_) async => dio.Response(
        data: json.decode(fixture('number.json')),
        statusCode: 200,
        statusMessage: "success",
        requestOptions: dio.RequestOptions(method: "Get", path: url)));
  }

  void setUpMockHttpClientSuccess404() async {
    mock.when(mockDio.get(any)).thenAnswer((_) async => dio.Response(
        data: null,
        statusCode: 404,
        statusMessage: failureMessage,
        requestOptions: dio.RequestOptions(
          method: "Get",
          path: url,
        )));
  }

  group('getItem', () {
    test(
      '''verify get method gets called with correct url''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteServiceImpl.getItem();
        // assert
        mock.verify(mockDio.get(url));
      },
    );

    test(
      'should return Iten when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await remoteServiceImpl.getItem();

        List<Item> items = result.fold((l) => null, (r) => r);
        // assert
        expect(items, isA<List<Item>>());
      },
    );

    test(
      'should return failure when the response code is 404 ',
      () async {
        // arrange
        setUpMockHttpClientSuccess404();
        // act
        final result = await remoteServiceImpl.getItem();

        Failure failure = result.fold((l) => l, (r) => null);

        // assert
        expect(failure.message, failureMessage);

        expect(failure, isA<Failure>());
      },
    );
  });
}
