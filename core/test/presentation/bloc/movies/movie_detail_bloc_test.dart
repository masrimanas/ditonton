import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/presentation/bloc/movies/movie_detail/movie_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieDetailBloc;

  const testId = 777;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  test('the initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) {
      bloc.add(LoadMovieDetail(testId));
    },
    expect: () {
      return [
        MovieDetailLoading(),
        MovieDetailHasData(testMovieDetail),
      ];
    },
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(testId));
      return movieDetailBloc.state.props;
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetMovieDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) {
      bloc.add(LoadMovieDetail(testId));
    },
    expect: () {
      return [MovieDetailLoading(), MovieDetailError('Server Failure')];
    },
    verify: (bloc) {
      return MovieDetailLoading();
    },
  );
}
