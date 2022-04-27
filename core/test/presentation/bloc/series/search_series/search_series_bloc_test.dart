import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/series.dart';
import 'package:core/domain/usecases/search_series.dart';
import 'package:core/presentation/bloc/series/search_series/search_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_series_bloc_test.mocks.dart';

@GenerateMocks([SearchSeries])
void main() {
  late SearchSeriesBloc searchSeriesBloc;
  late MockSearchSeries mockSearchSeries;

  setUp(() {
    mockSearchSeries = MockSearchSeries();
    searchSeriesBloc = SearchSeriesBloc(mockSearchSeries);
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
  final tQuery = 'Moon Knight';

  test('initial state should empty', () {
    expect(searchSeriesBloc.state, SearchSeriesEmpty());
  });

  blocTest<SearchSeriesBloc, SearchSeriesState>(
      'should emit [Loading, HasData] when data is obtained sucessfulle',
      build: () {
        when(mockSearchSeries.execute(tQuery))
            .thenAnswer((_) async => Right(tSeriesList));
        return searchSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 750),
      expect: () => [
            SearchSeriesLoading(),
            SearchSeriesHasData(tSeriesList),
          ],
      verify: (bloc) {
        verify(mockSearchSeries.execute(tQuery));
      });
}
