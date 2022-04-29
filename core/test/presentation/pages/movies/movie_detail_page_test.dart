import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/bloc/movies/movie_detail/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movies/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:core/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:core/presentation/pages/movies/movie_detail_page.dart';
import 'package:core/utils/state_enum.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class FakeMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieRecommendationsBloc
    extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState>
    implements MovieRecommendationsBloc {}

class FakeWatchlistMoviesBloc
    extends MockBloc<WatchlistMoviesEvent, WatchlistMoviesState>
    implements WatchlistMoviesBloc {}

void main() {
  late FakeMovieDetailBloc fakeMovieDetailBloc;
  late FakeMovieRecommendationsBloc fakeMovieRecommendationsBloc;
  late FakeWatchlistMoviesBloc fakeWatchlistMoviesBloc;

  setUpAll(() {
    fakeMovieDetailBloc = FakeMovieDetailBloc();
    fakeMovieRecommendationsBloc = FakeMovieRecommendationsBloc();
    fakeWatchlistMoviesBloc = FakeWatchlistMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>(
          create: (_) => fakeMovieDetailBloc,
        ),
        BlocProvider<MovieRecommendationsBloc>(
          create: (_) => fakeMovieRecommendationsBloc,
        ),
        BlocProvider<WatchlistMoviesBloc>(
          create: (_) => fakeWatchlistMoviesBloc,
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
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(testMovieList));
    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(MovieIsInWatchlist(false));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(testMovieList));
    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(MovieIsInWatchlist(true));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => fakeMovieDetailBloc.state)
        .thenReturn(MovieDetailHasData(testMovieDetail));
    when(() => fakeMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsHasData(testMovieList));
    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(MovieIsInWatchlist(true));
    when(() => fakeWatchlistMoviesBloc.state)
        .thenReturn(WatchlistMoviesMessage('Added to Watchlist'));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });
}
