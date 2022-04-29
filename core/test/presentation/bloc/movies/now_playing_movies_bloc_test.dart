import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/presentation/bloc/movies/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

  test('the initial state should be empty', () {
    expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadNowPlayingMovies());
    },
    expect: () {
      return [
        NowPlayingMoviesLoading(),
        NowPlayingMoviesHasData(testMovieList),
      ];
    },
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      return nowPlayingMoviesBloc.state.props;
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, Empty] when the data is empty',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadNowPlayingMovies());
    },
    expect: () {
      return [NowPlayingMoviesLoading(), NowPlayingMoviesEmpty()];
    },
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadNowPlayingMovies());
    },
    expect: () {
      return [
        NowPlayingMoviesLoading(),
        NowPlayingMoviesError('Server Failure')
      ];
    },
    verify: (bloc) {
      return NowPlayingMoviesLoading();
    },
  );
}
