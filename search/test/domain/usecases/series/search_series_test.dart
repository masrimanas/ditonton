import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_series.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchSeries usecase;
  late MockSeriesRepository mockSeriesRepository;

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = SearchSeries(mockSeriesRepository);
  });

  final tSeries = <Series>[];
  final tQuery = 'Spiderman';

  test('should get list of series from the repository', () async {
    // arrange
    when(mockSeriesRepository.searchSeries(tQuery))
        .thenAnswer((_) async => Right(tSeries));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tSeries));
  });
}
