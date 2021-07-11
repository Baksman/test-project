import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:localstorage/localstorage.dart';
import 'package:matcher/matcher.dart';
import 'package:project/datasources/local_data_source/local_database_service.dart';
import 'package:project/datasources/source_response/failure.dart';
import 'package:project/models/item.dart';
import '../fixture/number_reaader.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  LocalServiceImpl dataSource;
  MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = LocalServiceImpl(
      mockLocalStorage,
    );
  });

  group('getItems', () {
    test(
      'should return Right<Item> from LocalStorage when there is one in the cache',
      () async {
        // arrange
        when(mockLocalStorage.getItem("item")).thenAnswer((v) async {
          var map = json.decode(fixture('number.json'));
          return map;
        });
        // act
        final rFold = await dataSource.getItems();
        List<Item> items = rFold.fold((l) {
          return null;
        }, (r) => r);
        // assert
        verify(mockLocalStorage.getItem("item"));
        expect(items, isA<List<Item>>());
      },
    );

    test(
      'should return Left<Failure> from LocalStorage when there is no item in cache',
      () async {
        // arrange
        when(mockLocalStorage.getItem("item")).thenReturn(null);
        // act
        Failure failure;
        final rFold = await dataSource.getItems();
        rFold.fold((l) => failure = l, (r) => null);
        // assert
        verify(mockLocalStorage.getItem("item"));
        expect(failure, isA<Failure>());
      },
    );
  });
}
