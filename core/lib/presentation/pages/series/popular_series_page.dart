import 'package:core/presentation/bloc/series/popular_series/popular_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/widgets/series_card_list.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  @override
  _PopularSeriesPageState createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularSeriesBloc>().add(LoadPopularSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularSeriesBloc, PopularSeriesState>(
          builder: (context, state) {
            if (state is PopularSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return SeriesCard(state.result[index]);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text((state as PopularSeriesError).message),
              );
            }
          },
        ),
      ),
    );
  }
}
