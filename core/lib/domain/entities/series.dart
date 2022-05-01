import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Series extends Equatable {
  Series({
    this.adult,
    this.backdropPath,
    this.firstAirDate,
    this.genreIds,
    required this.id,
    this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.voteAverage,
    this.voteCount,
  });

  Series.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  bool? adult;
  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  final int id;
  String? name;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        name,
        numberOfEpisodes,
        numberOfSeasons,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
