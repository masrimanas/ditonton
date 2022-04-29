import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:core/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class FakeTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late FakeTopRatedMoviesBloc fakeTopRatedMoviesBloc;

  setUpAll(() {
    fakeTopRatedMoviesBloc = FakeTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>(
      create: (_) => fakeTopRatedMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    fakeTopRatedMoviesBloc.close();
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => fakeTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesError('Failed'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
