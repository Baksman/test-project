import 'package:dio/dio.dart' as dio;
import 'package:http_mock_adapter/http_mock_adapter.dart';
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
  // dio.Dio diocl = dio.Dio();
  MockDio mockDio;
  final dioAdapter = DioAdapter();
  // dio.httpClientAdapter = dioAdapter;
  MockLocalStorage mockLocalStorage;
  LocalServiceImpl dataSource;
  final incorrectUrl = "https://jsonplaceholder.typ8488fnhg";
  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockDio = MockDio();
    mockLocalStorage = MockLocalStorage();
    dataSource = LocalServiceImpl(
      mockLocalStorage,
    );
    remoteServiceImpl = RemoteServiceImpl(dataSource);
  });

  void setUpMockHttpClientSuccess200() async {
    mock.when(mockDio.get(incorrectUrl)).thenAnswer((_) async => dio.Response(
        data: fixture('number.json'),
        statusCode: 200,
        requestOptions: dio.RequestOptions(method: "Get", path: incorrectUrl)));
  }

  void setUpMockHttpClientSuccess400() {
    dioAdapter
      ..onGet(
        incorrectUrl,
        (request) => request.reply(200, {
          "userId": 1,
          "id": 1,
          "title":
              "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
          "body":
              "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
        }),
      );
  }

  group('getItem', () {
    test(
      '''verify  never called with incorrect incorrectUrl''',
      () async {
        // MockHttpClient()
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        remoteServiceImpl.getItem();
        // assert
        mock.verifyNever(mockDio.get(any));
      },
    );

    test("", () {
      
    });
  });
}
