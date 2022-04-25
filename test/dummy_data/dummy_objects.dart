import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);
final testSeries = Series(
  adult: false,
  backdropPath: '/tGWTz0aQrTaeGjax5Rlyhz7ImWD.jpg',
  firstAirDate: '2022-03-30',
  genreIds: [18, 10759, 10765],
  id: 92749,
  numberOfEpisodes: 6,
  numberOfSeasons: 1,
  originalName: 'Moon Knight',
  overview:
      'Marc & Steven must find balance as supernatural threats ahead look to stop them.',
  popularity: 8810.128,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  name: 'Moon Knight',
  voteAverage: 836,
  voteCount: 315,
);
final testMovieList = [testMovie];
final testSeriesList = [testSeries];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);
final testSeriesDetail = SeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  episodeRuntime: 47,
  firstAirDate: 'firstAirDate',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  numberOfSeasons: 1,
  numberOfEpisodes: 6,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  type: 'type',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);
final testWatchlistSeries = Series.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);
final testSeriesTable = SeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
final testSeriesMap = {
  'id': 1,
  'name': 'name',
  'overview': 'overview',
  'posterPath': 'posterPath',
};
