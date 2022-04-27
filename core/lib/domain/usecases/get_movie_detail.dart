import 'package:dartz/dartz.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../utils/failure.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
