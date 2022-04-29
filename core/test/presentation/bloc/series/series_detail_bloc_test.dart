import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_series_detail.dart';
import 'package:core/presentation/bloc/series/series_detail/series_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'series_detail_bloc_test.mocks.dart';

@GenerateMocks([GetSeriesDetail])
void main() {
  late MockGetSeriesDetail mockGetSeriesDetail;
  late SeriesDetailBloc seriesDetailBloc;

  const testId = 777;

  setUp(() {
    mockGetSeriesDetail = MockGetSeriesDetail();
    seriesDetailBloc = SeriesDetailBloc(mockGetSeriesDetail);
  });

  test('the initial state should be empty', () {
    expect(seriesDetailBloc.state, SeriesDetailEmpty());
  });

  blocTest<SeriesDetailBloc, SeriesDetailState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetSeriesDetail.execute(testId))
          .thenAnswer((_) async => Right(testSeriesDetail));
      return seriesDetailBloc;
    },
    act: (bloc) {
      bloc.add(LoadSeriesDetail(testId));
    },
    expect: () {
      return [
        SeriesDetailLoading(),
        SeriesDetailHasData(testSeriesDetail),
      ];
    },
    verify: (bloc) {
      verify(mockGetSeriesDetail.execute(testId));
      return seriesDetailBloc.state.props;
    },
  );

  blocTest<SeriesDetailBloc, SeriesDetailState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetSeriesDetail.execute(testId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return seriesDetailBloc;
    },
    act: (bloc) {
      bloc.add(LoadSeriesDetail(testId));
    },
    expect: () {
      return [SeriesDetailLoading(), SeriesDetailError('Server Failure')];
    },
    verify: (bloc) {
      return SeriesDetailLoading();
    },
  );
}
