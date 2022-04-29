import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/movies/movie_detail/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movies/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:core/presentation/bloc/movies/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../domain/entities/genre.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../styles/colors.dart';
import '../../../styles/text_styles.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/movie-detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieDetailBloc>().add(LoadMovieDetail(widget.id));
      context
          .read<MovieRecommendationsBloc>()
          .add(LoadMovieRecommendations(widget.id));
      context
          .read<WatchlistMoviesBloc>()
          .add(LoadWatchlistMoviesStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieWatchlistStatus =
        context.select<WatchlistMoviesBloc, bool>((bloc) {
      if (bloc.state is MovieIsInWatchlist) {
        return (bloc.state as MovieIsInWatchlist).isInWatchlist;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailHasData) {
            final movie = state.result;
            return SafeArea(
              child: DetailContent(
                movie,
                movieWatchlistStatus,
              ),
            );
          } else {
            return Text('Failed');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final MovieDetail movie;
  final bool isInWatchlist;

  DetailContent(this.movie, this.isInWatchlist);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  late bool isInWatchlist = widget.isInWatchlist;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!widget.isInWatchlist) {
                                  context
                                      .read<WatchlistMoviesBloc>()
                                      .add(AddMovieToWatchlist(widget.movie));
                                } else {
                                  context.read<WatchlistMoviesBloc>().add(
                                      RemoveMovieFromWatchlist(widget.movie));
                                }

                                final state =
                                    BlocProvider.of<WatchlistMoviesBloc>(
                                            context)
                                        .state;
                                String message = '';
                                if (state is MovieIsInWatchlist) {
                                  final isInWatchlist = state.isInWatchlist;
                                  message = isInWatchlist == false
                                      ? 'Added to Watchlist'
                                      : 'Removed from Watchlist';
                                } else {
                                  message = !isInWatchlist
                                      ? 'Added to Watchlist'
                                      : 'Removed from Watchlist';
                                }

                                if (message == 'Added to Watchlist' ||
                                    message == 'Removed from Watchlist') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                                setState(() {
                                  isInWatchlist = !isInWatchlist;
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isInWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.movie.genres),
                            ),
                            Text(
                              _showDuration(widget.movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MovieRecommendationsBloc,
                                MovieRecommendationsState>(
                              builder: (context, state) {
                                if (state is MovieRecommendationsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is MovieRecommendationsError) {
                                  return Text(state.message);
                                } else if (state
                                    is MovieRecommendationsHasData) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.result.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
