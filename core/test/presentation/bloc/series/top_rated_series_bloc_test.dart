import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_top_rated_series.dart';
import 'package:core/presentation/bloc/series/top_rated_series/top_rated_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedSeries])
void main() {
  late MockGetTopRatedSeries mockGetTopRatedSeries;
  late TopRatedSeriesBloc topRatedSeriesBloc;

  setUp(() {
    mockGetTopRatedSeries = MockGetTopRatedSeries();
    topRatedSeriesBloc = TopRatedSeriesBloc(mockGetTopRatedSeries);
  });

  test('the initial state should be empty', () {
    expect(topRatedSeriesBloc.state, TopRatedSeriesEmpty());
  });

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadTopRatedSeries());
    },
    expect: () {
      return [
        TopRatedSeriesLoading(),
        TopRatedSeriesHasData(testSeriesList),
      ];
    },
    verify: (bloc) {
      verify(mockGetTopRatedSeries.execute());
      return topRatedSeriesBloc.state.props;
    },
  );

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'should emit [Loading, Empty] when the data is empty',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => const Right([]));
      return topRatedSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadTopRatedSeries());
    },
    expect: () {
      return [TopRatedSeriesLoading(), TopRatedSeriesEmpty()];
    },
  );

  blocTest<TopRatedSeriesBloc, TopRatedSeriesState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadTopRatedSeries());
    },
    expect: () {
      return [TopRatedSeriesLoading(), TopRatedSeriesError('Server Failure')];
    },
    verify: (bloc) {
      return TopRatedSeriesLoading();
    },
  );
}
