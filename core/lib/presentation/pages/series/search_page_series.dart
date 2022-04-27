import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../presentation/widgets/series_card_list.dart';
import '../../../presentation/bloc/series/search_series/search_series_bloc.dart';
import '../../../styles/text_styles.dart';

class SearchPageSeries extends StatelessWidget {
  static const ROUTE_NAME = '/search-series';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchSeriesBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchSeriesBloc, SearchSeriesState>(
                builder: (context, state) {
              if (state is SearchSeriesLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SearchSeriesHasData) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      final series = result[index];
                      return SeriesCard(series);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is SearchSeriesError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
