import 'package:flutter/material.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';
import '../widgets/card_swiper.dart';
import '../widgets/movie_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Peliculas en cines"),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CartSwipe(movies: moviesProvider.onDisplayMovies),
              MovieSlider(
                title: 'Populares',
                movies: moviesProvider.onpopularMovies,
                onNextPage: () {
                  moviesProvider.getPopularMovies();
                },
              ),
            ],
          ),
        ));
  }
}
