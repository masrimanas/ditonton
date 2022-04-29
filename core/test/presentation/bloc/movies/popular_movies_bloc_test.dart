import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  test('the initial state should be empty', () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadPopularMovies());
    },
    expect: () {
      return [
        PopularMoviesLoading(),
        PopularMoviesHasData(testMovieList),
      ];
    },
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
      return popularMoviesBloc.state.props;
    },
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [Loading, Empty] when the data is unsucessfully fetched',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return popularMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadPopularMovies());
    },
    expect: () {
      return [PopularMoviesLoading(), PopularMoviesEmpty()];
    },
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [Loading, Error] when the data is empty',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) {
      bloc.add(LoadPopularMovies());
    },
    expect: () {
      return [PopularMoviesLoading(), PopularMoviesError('Server Failure')];
    },
    verify: (bloc) {
      return PopularMoviesLoading();
    },
  );
}
