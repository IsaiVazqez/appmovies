import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search Movie';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () => query = '', icon: const Icon(CupertinoIcons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(CupertinoIcons.back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Icon(CupertinoIcons.film, color: Colors.black38, size: 140),
    );
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(CupertinoIcons.film, color: Colors.black38, size: 140),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => _MovieItem(movie: movies[index]));
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        placeholder: const AssetImage('assets/no-image.jpg'),
        image: NetworkImage(movie.fullPosterImg),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
