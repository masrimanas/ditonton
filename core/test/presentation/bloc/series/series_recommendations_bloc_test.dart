import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_series_recommendations.dart';
import 'package:core/presentation/bloc/series/series_recommendations/series_recommendations_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'series_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetSeriesRecommendations])
void main() {
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;
  late SeriesRecommendationsBloc seriesRecommendationsBloc;

  const testId = 777;

  setUp(() {
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    seriesRecommendationsBloc =
        SeriesRecommendationsBloc(mockGetSeriesRecommendations);
  });

  test('the initial state should be empty', () {
    expect(seriesRecommendationsBloc.state, SeriesRecommendationsEmpty());
  });

  blocTest<SeriesRecommendationsBloc, SeriesRecommendationsState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Right(testSeriesList));
      return seriesRecommendationsBloc;
    },
    act: (bloc) {
      bloc.add(LoadSeriesRecommendations(testId));
    },
    expect: () {
      return [
        SeriesRecommendationsLoading(),
        SeriesRecommendationsHasData(testSeriesList),
      ];
    },
    verify: (bloc) {
      verify(mockGetSeriesRecommendations.execute(testId));
      return seriesRecommendationsBloc.state.props;
    },
  );

  blocTest<SeriesRecommendationsBloc, SeriesRecommendationsState>(
    'should emit [Loading, Empty] when the data is empty',
    build: () {
      when(mockGetSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => const Right([]));
      return seriesRecommendationsBloc;
    },
    act: (bloc) {
      bloc.add(LoadSeriesRecommendations(testId));
    },
    expect: () {
      return [SeriesRecommendationsLoading(), SeriesRecommendationsEmpty()];
    },
  );

  blocTest<SeriesRecommendationsBloc, SeriesRecommendationsState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetSeriesRecommendations.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesRecommendationsBloc;
    },
    act: (bloc) {
      bloc.add(LoadSeriesRecommendations(testId));
    },
    expect: () {
      return [
        SeriesRecommendationsLoading(),
        SeriesRecommendationsError('Server Failure')
      ];
    },
    verify: (bloc) {
      return SeriesRecommendationsLoading();
    },
  );
}
