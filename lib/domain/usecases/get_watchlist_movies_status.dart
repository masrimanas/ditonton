import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetWatchListMoviesStatus {
  final MovieRepository repository;

  GetWatchListMoviesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
