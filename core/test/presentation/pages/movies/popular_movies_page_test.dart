import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/movies/popular_movies/popular_movies_bloc.dart';
import 'package:core/presentation/pages/movies/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class FakePopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late FakePopularMoviesBloc fakePopularMoviesBloc;

  setUpAll(() {
    fakePopularMoviesBloc = FakePopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>(
      create: (_) => fakePopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakePopularMoviesBloc.state).thenReturn(PopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => fakePopularMoviesBloc.state)
        .thenReturn(PopularMoviesHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakePopularMoviesBloc.state)
        .thenReturn(PopularMoviesError('Failed'));
    when(() => fakePopularMoviesBloc.state)
        .thenReturn(PopularMoviesError('Failed'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
