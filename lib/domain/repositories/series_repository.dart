import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class SeriesRepository {
  Future<Either<Failure, List<Series>>> getPopularSeries();
  Future<Either<Failure, List<Series>>> getOnGoingSeries();
  Future<Either<Failure, List<Series>>> getTopRatedSeries();
  Future<Either<Failure, SeriesDetail>> getSeriesDetail(int id);
  Future<Either<Failure, List<Series>>> getSeriesRecommendations(int id);
  Future<Either<Failure, List<Series>>> searchSeries(String query);
  Future<Either<Failure, String>> saveWatchlistSeries(SeriesDetail series);
  Future<Either<Failure, String>> removeWatchlistSeries(SeriesDetail series);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Series>>> getWatchlistSeries();
}
