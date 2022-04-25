import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/repositories/series_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetOnGoingSeries {
  final SeriesRepository repository;

  GetOnGoingSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getOnGoingSeries();
  }
}
