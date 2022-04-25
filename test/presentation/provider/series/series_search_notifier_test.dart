import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/search_series.dart';
import 'package:ditonton/presentation/provider/series/series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchSeries])
void main() {
  late SeriesSearchNotifier provider;
  late MockSearchSeries mockSearchSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchSeries = MockSearchSeries();
    provider = SeriesSearchNotifier(searchSeries: mockSearchSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tSeriesModel = Series(
    adult: false,
    backdropPath: '/tGWTz0aQrTaeGjax5Rlyhz7ImWD.jpg',
    firstAirDate: '2022-03-30',
    genreIds: [18, 10759, 10765],
    id: 92749,
    numberOfEpisodes: 6,
    numberOfSeasons: 1,
    originalName: 'Moon Knight',
    overview:
        'Marc & Steven must find balance as supernatural threats ahead look to stop them.',
    popularity: 8810.128,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    name: 'Moon Knight',
    voteAverage: 836,
    voteCount: 315,
  );
  final tSeriesList = <Series>[tSeriesModel];
  final tQuery = 'spiderman';

  group('search series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tSeriesList));
      // act
      await provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
