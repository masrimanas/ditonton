import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/presentation/bloc/movies/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationsBloc movieRecommendationsBloc;

  const testId = 777;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationsBloc =
        MovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  test('the initial state should be empty', () {
    expect(movieRecommendationsBloc.state, MovieRecommendationsEmpty());
  });

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testMovieList));
      return movieRecommendationsBloc;
    },
    act: (bloc) {
      bloc.add(LoadMovieRecommendations(testId));
    },
    expect: () {
      return [
        MovieRecommendationsLoading(),
        MovieRecommendationsHasData(testMovieList),
      ];
    },
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(testId));
      return movieRecommendationsBloc.state.props;
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit [Loading, Empty] when the data is empty',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => const Right([]));
      return movieRecommendationsBloc;
    },
    act: (bloc) {
      bloc.add(LoadMovieRecommendations(testId));
    },
    expect: () {
      return [MovieRecommendationsLoading(), MovieRecommendationsEmpty()];
    },
  );

  blocTest<MovieRecommendationsBloc, MovieRecommendationsState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetMovieRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieRecommendationsBloc;
    },
    act: (bloc) {
      bloc.add(LoadMovieRecommendations(testId));
    },
    expect: () {
      return [
        MovieRecommendationsLoading(),
        MovieRecommendationsError('Server Failure')
      ];
    },
    verify: (bloc) {
      return MovieRecommendationsLoading();
    },
  );
}
