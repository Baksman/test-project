import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:mockito/mockito.dart' as mock;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project/datasources/local_data_source/local_database_service.dart';
import 'package:project/datasources/remote_data_source/remote_service.dart';
import '../fixture/number_reaader.dart';
import 'local_datasource_test.dart';

class MockDio extends mock.Mock implements dio.Dio {}

void main() async {
  RemoteServiceImpl remoteServiceImpl;
  MockDio mockDio;
  MockLocalStorage mockLocalStorage;
  LocalServiceImpl dataSource;
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
        requestOptions: dio.RequestOptions(method: "Get", path: url)));
  }


  group('getItem', () {
    test(
      '''verify get method gets called with correct url''',
      () async {
        // MockHttpClient()
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteServiceImpl.getItem();
        // assert
        mock.verify(mockDio.get(url));
      },
    );
  });
}
