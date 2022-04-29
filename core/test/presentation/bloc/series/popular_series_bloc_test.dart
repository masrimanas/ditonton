import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_popular_series.dart';
import 'package:core/presentation/bloc/series/popular_series/popular_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularSeries])
void main() {
  late MockGetPopularSeries mockGetPopularSeries;
  late PopularSeriesBloc popularSeriesBloc;

  setUp(() {
    mockGetPopularSeries = MockGetPopularSeries();
    popularSeriesBloc = PopularSeriesBloc(mockGetPopularSeries);
  });

  test('the initial state should be empty', () {
    expect(popularSeriesBloc.state, PopularSeriesEmpty());
  });

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadPopularSeries());
    },
    expect: () {
      return [
        PopularSeriesLoading(),
        PopularSeriesHasData(testSeriesList),
      ];
    },
    verify: (bloc) {
      verify(mockGetPopularSeries.execute());
      return popularSeriesBloc.state.props;
    },
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'should emit [Loading, Empty] when the data is unsucessfully fetched',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => const Right([]));
      return popularSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadPopularSeries());
    },
    expect: () {
      return [PopularSeriesLoading(), PopularSeriesEmpty()];
    },
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'should emit [Loading, Error] when the data is empty',
    build: () {
      when(mockGetPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadPopularSeries());
    },
    expect: () {
      return [PopularSeriesLoading(), PopularSeriesError('Server Failure')];
    },
    verify: (bloc) {
      return PopularSeriesLoading();
    },
  );
}
