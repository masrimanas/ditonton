import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/get_on_going_series.dart';
import 'package:core/presentation/bloc/series/on_going_series/on_going_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'on_going_series_bloc_test.mocks.dart';

@GenerateMocks([GetOnGoingSeries])
void main() {
  late MockGetOnGoingSeries mockGetOnGoingSeries;
  late OnGoingSeriesBloc onGoingSeriesBloc;

  setUp(() {
    mockGetOnGoingSeries = MockGetOnGoingSeries();
    onGoingSeriesBloc = OnGoingSeriesBloc(mockGetOnGoingSeries);
  });

  test('the initial state should be empty', () {
    expect(onGoingSeriesBloc.state, OnGoingSeriesEmpty());
  });

  blocTest<OnGoingSeriesBloc, OnGoingSeriesState>(
    'should emit [Loading, HasData] state when data is sucessfully fetched',
    build: () {
      when(mockGetOnGoingSeries.execute())
          .thenAnswer((_) async => Right(testSeriesList));
      return onGoingSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadOnGoingSeries());
    },
    expect: () {
      return [
        OnGoingSeriesLoading(),
        OnGoingSeriesHasData(testSeriesList),
      ];
    },
    verify: (bloc) {
      verify(mockGetOnGoingSeries.execute());
      return onGoingSeriesBloc.state.props;
    },
  );

  blocTest<OnGoingSeriesBloc, OnGoingSeriesState>(
    'should emit [Loading, Empty] when the data is empty',
    build: () {
      when(mockGetOnGoingSeries.execute())
          .thenAnswer((_) async => const Right([]));
      return onGoingSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadOnGoingSeries());
    },
    expect: () {
      return [OnGoingSeriesLoading(), OnGoingSeriesEmpty()];
    },
  );

  blocTest<OnGoingSeriesBloc, OnGoingSeriesState>(
    'should emit [Loading, Error] when the data is unsucessfully fetched',
    build: () {
      when(mockGetOnGoingSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return onGoingSeriesBloc;
    },
    act: (bloc) {
      bloc.add(LoadOnGoingSeries());
    },
    expect: () {
      return [OnGoingSeriesLoading(), OnGoingSeriesError('Server Failure')];
    },
    verify: (bloc) {
      return OnGoingSeriesLoading();
    },
  );
}
