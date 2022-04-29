import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_movies_status.dart';
import 'package:core/domain/usecases/remove_watchlist_movies.dart';
import 'package:core/domain/usecases/save_watchlist_movies.dart';
import 'package:core/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListMoviesStatus,
  RemoveWatchlistMovies,
  SaveWatchlistMovies,
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListMoviesStatus mockGetWatchListMoviesStatus;
  late MockRemoveWatchlistMovies mockRemoveWatchlistMovies;
  late MockSaveWatchlistMovies mockSaveWatchlistMovies;
  late WatchlistMoviesBloc watchlistMoviesBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListMoviesStatus = MockGetWatchListMoviesStatus();
    mockRemoveWatchlistMovies = MockRemoveWatchlistMovies();
    mockSaveWatchlistMovies = MockSaveWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(
      mockGetWatchlistMovies,
      mockGetWatchListMoviesStatus,
      mockRemoveWatchlistMovies,
      mockSaveWatchlistMovies,
    );
  });

  test('the initial state should be empty', () {
    expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
  });

  group('GetWatchlistMovies tests', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [Loading, HasData] state when data is sucessfully fetched',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return watchlistMoviesBloc;
      },
      act: (bloc) {
        bloc.add(LoadWatchlistMovies());
      },
      expect: () {
        return [
          WatchlistMoviesLoading(),
          WatchlistMoviesHasData(testMovieList),
        ];
      },
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
        return watchlistMoviesBloc.state.props;
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [Loading, Empty] when the data is empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistMoviesBloc;
      },
      act: (bloc) {
        bloc.add(LoadWatchlistMovies());
      },
      expect: () {
        return [WatchlistMoviesLoading(), WatchlistMoviesEmpty()];
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should emit [Loading, Error] when the data is unsucessfully fetched',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistMoviesBloc;
      },
      act: (bloc) {
        bloc.add(LoadWatchlistMovies());
      },
      expect: () {
        return [
          WatchlistMoviesLoading(),
          WatchlistMoviesError('Server Failure')
        ];
      },
      verify: (bloc) {
        return WatchlistMoviesLoading();
      },
    );
  });

  group('GetWatchlistMoviesStatus test', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should be true when the movie watchlist status is also true',
      build: () {
        when(mockGetWatchListMoviesStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistMoviesStatus(testMovieDetail.id)),
      expect: () => [
        MovieIsInWatchlist(true),
      ],
      verify: (bloc) {
        verify(mockGetWatchListMoviesStatus.execute(testMovieDetail.id));
        return watchlistMoviesBloc.state.props;
      },
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'should be false when the watchlist movie status is also false',
      build: () {
        when(mockGetWatchListMoviesStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistMoviesStatus(testMovieDetail.id)),
      expect: () => [
        MovieIsInWatchlist(false),
      ],
      verify: (bloc) {
        verify(mockGetWatchListMoviesStatus.execute(testMovieDetail.id));
        return watchlistMoviesBloc.state.props;
      },
    );
  });

  group(
    'AddWatchlistMovies tests',
    () {
      blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
        'should update watchlist movie status when it is successfully added',
        build: () {
          when(mockSaveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Added to Watchlist'));
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
        expect: () => [
          WatchlistMoviesMessage('Added to Watchlist'),
        ],
        verify: (bloc) {
          verify(mockSaveWatchlistMovies.execute(testMovieDetail));
          return watchlistMoviesBloc.state.props;
        },
      );

      blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
        'should update watchlist movie status when it is unsuccessfully added',
        build: () {
          when(mockSaveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
        expect: () => [
          WatchlistMoviesError('Failed'),
        ],
        verify: (bloc) {
          verify(mockSaveWatchlistMovies.execute(testMovieDetail));
          return watchlistMoviesBloc.state.props;
        },
      );
    },
  );

  group(
    'RemoveWatchlistMovies tests',
    () {
      blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
        'should update watchlist movie status when it is successfully removed',
        build: () {
          when(mockRemoveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Removed from Watchlist'));
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
        expect: () => [
          WatchlistMoviesMessage('Removed from Watchlist'),
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
          return watchlistMoviesBloc.state.props;
        },
      );

      blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
        'should update watchlist movie status when it is unsuccessfully removed',
        build: () {
          when(mockRemoveWatchlistMovies.execute(testMovieDetail))
              .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
          return watchlistMoviesBloc;
        },
        act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
        expect: () => [
          WatchlistMoviesError('Failed'),
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistMovies.execute(testMovieDetail));
          return watchlistMoviesBloc.state.props;
        },
      );
    },
  );
}
