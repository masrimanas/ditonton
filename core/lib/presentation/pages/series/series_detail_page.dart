import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/series/series_detail/series_detail_bloc.dart';
import 'package:core/presentation/bloc/series/series_recommendations/series_recommendations_bloc.dart';
import 'package:core/presentation/bloc/series/watchlist_series/watchlist_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../domain/entities/genre.dart';
import '../../../domain/entities/series_detail.dart';
import '../../../styles/colors.dart';
import '../../../styles/text_styles.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/series-detail';

  final int id;
  SeriesDetailPage({required this.id});

  @override
  _SeriesDetailPageState createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SeriesDetailBloc>().add(LoadSeriesDetail(widget.id));
      context
          .read<SeriesRecommendationsBloc>()
          .add(LoadSeriesRecommendations(widget.id));
      context
          .read<WatchlistSeriesBloc>()
          .add(LoadWatchlistSeriesStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final seriesWatchlistStatus =
        context.select<WatchlistSeriesBloc, bool>((bloc) {
      if (bloc.state is SeriesIsInWatchlist) {
        return (bloc.state as SeriesIsInWatchlist).isInWatchlist;
      }
      return false;
    });
    return Scaffold(
      body: BlocBuilder<SeriesDetailBloc, SeriesDetailState>(
        builder: (context, state) {
          if (state is SeriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SeriesDetailHasData) {
            final series = state.result;
            return SafeArea(
              child: DetailContent(
                series,
                seriesWatchlistStatus,
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
  final SeriesDetail series;
  final bool isInWatchlist;

  DetailContent(this.series, this.isInWatchlist);

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
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.series.posterPath}',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.series.name,
                                  style: kHeading5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: kOxfordBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Text(
                                    _showSeason(widget.series.numberOfSeasons),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!widget.isInWatchlist) {
                                  context
                                      .read<WatchlistSeriesBloc>()
                                      .add(AddSeriesToWatchlist(widget.series));
                                } else {
                                  context.read<WatchlistSeriesBloc>().add(
                                      RemoveSeriesFromWatchlist(widget.series));
                                }

                                final state =
                                    BlocProvider.of<WatchlistSeriesBloc>(
                                            context)
                                        .state;
                                String message = '';
                                if (state is SeriesIsInWatchlist) {
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
                              _showGenres(widget.series.genres),
                            ),
                            Text('${widget.series.numberOfEpisodes} Episodes'),
                            Text(
                              _showDuration(widget.series.episodeRuntime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.series.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.series.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.series.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<SeriesRecommendationsBloc,
                                SeriesRecommendationsState>(
                              builder: (context, state) {
                                if (state is SeriesRecommendationsLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state
                                    is SeriesRecommendationsError) {
                                  return Text(state.message);
                                } else if (state
                                    is SeriesRecommendationsHasData) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final series = state.result[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                SeriesDetailPage.ROUTE_NAME,
                                                arguments: series.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${series.posterPath}',
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

  String _showSeason(int season) {
    if (season > 1) {
      return '${season} Seasons';
    } else {
      return '${season} Season';
    }
  }
}
