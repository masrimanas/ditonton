import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_series.dart';
import 'package:core/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:core/presentation/bloc/series/watchlist_series/watchlist_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistSeries,
  GetWatchListSeriesStatus,
  RemoveWatchlistSeries,
  SaveWatchlistSeries,
])
void main() {
  late MockGetWatchlistSeries mockGetWatchlistSeries;
  late MockGetWatchListSeriesStatus mockGetWatchListSeriesStatus;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;
  late MockSaveWatchlistSeries mockSaveWatchlistSeries;
  late WatchlistSeriesBloc watchlistSeriesBloc;

  setUp(() {
    mockGetWatchlistSeries = MockGetWatchlistSeries();
    mockGetWatchListSeriesStatus = MockGetWatchListSeriesStatus();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    watchlistSeriesBloc = WatchlistSeriesBloc(
      mockGetWatchlistSeries,
      mockGetWatchListSeriesStatus,
      mockRemoveWatchlistSeries,
      mockSaveWatchlistSeries,
    );
  });

  test('the initial state should be empty', () {
    expect(watchlistSeriesBloc.state, WatchlistSeriesEmpty());
  });

  group('GetWatchlistSeries tests', () {
    blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
      'should emit [Loading, HasData] state when data is sucessfully fetched',
      build: () {
        when(mockGetWatchlistSeries.execute())
            .thenAnswer((_) async => Right(testSeriesList));
        return watchlistSeriesBloc;
      },
      act: (bloc) {
        bloc.add(LoadWatchlistSeries());
      },
      expect: () {
        return [
          WatchlistSeriesLoading(),
          WatchlistSeriesHasData(testSeriesList),
        ];
      },
      verify: (bloc) {
        verify(mockGetWatchlistSeries.execute());
        return watchlistSeriesBloc.state.props;
      },
    );

    blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
      'should emit [Loading, Empty] when the data is empty',
      build: () {
        when(mockGetWatchlistSeries.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistSeriesBloc;
      },
      act: (bloc) {
        bloc.add(LoadWatchlistSeries());
      },
      expect: () {
        return [WatchlistSeriesLoading(), WatchlistSeriesEmpty()];
      },
    );

    blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
      'should emit [Loading, Error] when the data is unsucessfully fetched',
      build: () {
        when(mockGetWatchlistSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistSeriesBloc;
      },
      act: (bloc) {
        bloc.add(LoadWatchlistSeries());
      },
      expect: () {
        return [
          WatchlistSeriesLoading(),
          WatchlistSeriesError('Server Failure')
        ];
      },
      verify: (bloc) {
        return WatchlistSeriesLoading();
      },
    );
  });

  group('GetWatchlistSeriesStatus test', () {
    blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
      'should be true when the series watchlist status is also true',
      build: () {
        when(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => true);
        return watchlistSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistSeriesStatus(testSeriesDetail.id)),
      expect: () => [
        SeriesIsInWatchlist(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id));
        return watchlistSeriesBloc.state.props;
      },
    );

    blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
      'should be false when the watchlist series status is also false',
      build: () {
        when(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id))
            .thenAnswer((_) async => false);
        return watchlistSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistSeriesStatus(testSeriesDetail.id)),
      expect: () => [
        SeriesIsInWatchlist(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListSeriesStatus.execute(testSeriesDetail.id));
        return watchlistSeriesBloc.state.props;
      },
    );
  });

  group(
    'AddWatchlistSeries tests',
    () {
      blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
        'should update watchlist series status when it is successfully added',
        build: () {
          when(mockSaveWatchlistSeries.execute(testSeriesDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          return watchlistSeriesBloc;
        },
        act: (bloc) => bloc.add(AddSeriesToWatchlist(testSeriesDetail)),
        expect: () => [
          WatchlistSeriesMessage('Added to Watchlist'),
        ],
        verify: (bloc) {
          verify(mockSaveWatchlistSeries.execute(testSeriesDetail));
          return watchlistSeriesBloc.state.props;
        },
      );

      blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
        'should update watchlist series status when it is unsuccessfully added',
        build: () {
          when(mockSaveWatchlistSeries.execute(testSeriesDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          return watchlistSeriesBloc;
        },
        act: (bloc) => bloc.add(AddSeriesToWatchlist(testSeriesDetail)),
        expect: () => [
          WatchlistSeriesError('Failed'),
        ],
        verify: (bloc) {
          verify(mockSaveWatchlistSeries.execute(testSeriesDetail));
          return watchlistSeriesBloc.state.props;
        },
      );
    },
  );

  group(
    'RemoveWatchlistSeries tests',
    () {
      blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
        'should update watchlist series status when it is successfully removed',
        build: () {
          when(mockRemoveWatchlistSeries.execute(testSeriesDetail))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          return watchlistSeriesBloc;
        },
        act: (bloc) => bloc.add(RemoveSeriesFromWatchlist(testSeriesDetail)),
        expect: () => [
          WatchlistSeriesMessage('Removed from Watchlist'),
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistSeries.execute(testSeriesDetail));
          return watchlistSeriesBloc.state.props;
        },
      );

      blocTest<WatchlistSeriesBloc, WatchlistSeriesState>(
        'should update watchlist series status when it is unsuccessfully removed',
        build: () {
          when(mockRemoveWatchlistSeries.execute(testSeriesDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          return watchlistSeriesBloc;
        },
        act: (bloc) => bloc.add(RemoveSeriesFromWatchlist(testSeriesDetail)),
        expect: () => [
          WatchlistSeriesError('Failed'),
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistSeries.execute(testSeriesDetail));
          return watchlistSeriesBloc.state.props;
        },
      );
    },
  );
}
