import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/series/on_going_series/on_going_series_bloc.dart';
import 'package:core/presentation/bloc/series/popular_series/popular_series_bloc.dart';
import 'package:core/presentation/bloc/series/top_rated_series/top_rated_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/pages/series/search_page_series.dart';

import '../../../domain/entities/series.dart';
import '../../../presentation/pages/series/series_detail_page.dart';
import '../../../presentation/pages/series/popular_series_page.dart';
import '../../../presentation/pages/series/top_rated_series_page.dart';
import '../../../presentation/pages/series/watchlist_series_page.dart';
import '../../../styles/text_styles.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes.dart';

class HomeSeriesPage extends StatefulWidget {
  static const ROUTE = '/home-series';
  @override
  _HomeSeriesPageState createState() => _HomeSeriesPageState();
}

class _HomeSeriesPageState extends State<HomeSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OnGoingSeriesBloc>().add(LoadOnGoingSeries());
      context.read<PopularSeriesBloc>().add(LoadPopularSeries());
      context.read<TopRatedSeriesBloc>().add(LoadTopRatedSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_sharp),
              title: Text('Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistSeriesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton - Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageSeries.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<OnGoingSeriesBloc, OnGoingSeriesState>(
                  builder: (context, state) {
                if (state is OnGoingSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnGoingSeriesHasData) {
                  return SeriesList(state.result);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularSeriesBloc, PopularSeriesState>(
                  builder: (context, state) {
                if (state is PopularSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularSeriesHasData) {
                  return SeriesList(state.result);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedSeriesBloc, TopRatedSeriesState>(
                  builder: (context, state) {
                if (state is TopRatedSeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedSeriesHasData) {
                  return SeriesList(state.result);
                } else {
                  return Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class SeriesList extends StatelessWidget {
  final List<Series> series;

  SeriesList(this.series);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final serieses = series[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SeriesDetailPage.ROUTE_NAME,
                  arguments: serieses.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${serieses.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: series.length,
      ),
    );
  }
}
