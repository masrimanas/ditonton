import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/series/series_detail/series_detail_bloc.dart';
import 'package:core/presentation/bloc/series/series_recommendations/series_recommendations_bloc.dart';
import 'package:core/presentation/bloc/series/watchlist_series/watchlist_series_bloc.dart';
import 'package:core/presentation/pages/series/series_detail_page.dart';
import 'package:core/utils/state_enum.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class FakeSeriesDetailBloc
    extends MockBloc<SeriesDetailEvent, SeriesDetailState>
    implements SeriesDetailBloc {}

class FakeSeriesRecommendationsBloc
    extends MockBloc<SeriesRecommendationsEvent, SeriesRecommendationsState>
    implements SeriesRecommendationsBloc {}

class FakeWatchlistSeriesBloc
    extends MockBloc<WatchlistSeriesEvent, WatchlistSeriesState>
    implements WatchlistSeriesBloc {}

void main() {
  late FakeSeriesDetailBloc fakeSeriesDetailBloc;
  late FakeSeriesRecommendationsBloc fakeSeriesRecommendationsBloc;
  late FakeWatchlistSeriesBloc fakeWatchlistSeriesBloc;

  setUpAll(() {
    fakeSeriesDetailBloc = FakeSeriesDetailBloc();
    fakeSeriesRecommendationsBloc = FakeSeriesRecommendationsBloc();
    fakeWatchlistSeriesBloc = FakeWatchlistSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SeriesDetailBloc>(
          create: (_) => fakeSeriesDetailBloc,
        ),
        BlocProvider<SeriesRecommendationsBloc>(
          create: (_) => fakeSeriesRecommendationsBloc,
        ),
        BlocProvider<WatchlistSeriesBloc>(
          create: (_) => fakeWatchlistSeriesBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeSeriesDetailBloc.state)
        .thenReturn(SeriesDetailHasData(testSeriesDetail));
    when(() => fakeSeriesRecommendationsBloc.state)
        .thenReturn(SeriesRecommendationsHasData(testSeriesList));
    when(() => fakeWatchlistSeriesBloc.state)
        .thenReturn(SeriesIsInWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeSeriesDetailBloc.state)
        .thenReturn(SeriesDetailHasData(testSeriesDetail));
    when(() => fakeSeriesRecommendationsBloc.state)
        .thenReturn(SeriesRecommendationsHasData(testSeriesList));
    when(() => fakeWatchlistSeriesBloc.state)
        .thenReturn(SeriesIsInWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeSeriesDetailBloc.state)
        .thenReturn(SeriesDetailHasData(testSeriesDetail));
    when(() => fakeSeriesRecommendationsBloc.state)
        .thenReturn(SeriesRecommendationsHasData(testSeriesList));
    when(() => fakeWatchlistSeriesBloc.state)
        .thenReturn(SeriesIsInWatchlist(true));
    when(() => fakeWatchlistSeriesBloc.state)
        .thenReturn(WatchlistSeriesMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
