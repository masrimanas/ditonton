import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/series/top_rated_series/top_rated_series_bloc.dart';
import 'package:core/presentation/pages/series/top_rated_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class FakeTopRatedSeriesBloc
    extends MockBloc<TopRatedSeriesEvent, TopRatedSeriesState>
    implements TopRatedSeriesBloc {}

void main() {
  late FakeTopRatedSeriesBloc fakeTopRatedSeriesBloc;

  setUpAll(() {
    fakeTopRatedSeriesBloc = FakeTopRatedSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedSeriesBloc>(
      create: (_) => fakeTopRatedSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeTopRatedSeriesBloc.close();
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakeTopRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeTopRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesHasData(testSeriesList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeTopRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesError('Failed'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
