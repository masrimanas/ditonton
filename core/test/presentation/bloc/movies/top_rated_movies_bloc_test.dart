import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('the initial state should be empty', () {
    expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadTopRatedMovies());
    },
    expect: () {
      return [
        TopRatedMoviesLoading(),
        TopRatedMoviesHasData(testMovieList),
      ];
    },
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
      return topRatedMoviesBloc.state.props;
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Empty] when the data is empty',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return topRatedMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadTopRatedMovies());
    },
    expect: () {
      return [TopRatedMoviesLoading(), TopRatedMoviesEmpty()];
    },
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadTopRatedMovies());
    },
    expect: () {
      return [TopRatedMoviesLoading(), TopRatedMoviesError('Server Failure')];
    },
    verify: (bloc) {
      return TopRatedMoviesLoading();
    },
  );
}
