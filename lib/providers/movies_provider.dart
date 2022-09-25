import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/now_playing_response.dart';
import 'package:movies_app/models/popular_response.dart';
import 'package:movies_app/models/search_response.dart';

import '../helpers/debouncer.dart';
import '../models/credits_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '1857d2a5d29e3fdfc67803cc372182ee';

  final String _baseUrl = 'api.themoviedb.org';

  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];

  List<Movie> onpopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _sugestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get sugestionStream => _sugestionStreamController.stream;

  MoviesProvider() {
    // ignore: avoid_print
    print('movies provider inicializado');

    // ignore: unnecessary_this
    this.getOnDisplaymovies();
    // ignore: unnecessary_this
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    var response = await http.get(url);

    return response.body;
  }

  getOnDisplaymovies() async {
    // ignore: unnecessary_this
    final jsonData = await this._getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    // ignore: avoid_print
    print(nowPlayingResponse.results[1].title);

    onDisplayMovies = [...nowPlayingResponse.results];

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    // ignore: unnecessary_this
    final jsonData = await this._getJsonData('/3/movie/popular', _popularPage);

    final populaResponse = PopularResponse.fromJson(jsonData);

    // ignore: avoid_print
    print(populaResponse.results[1].title);

    onpopularMovies = [...onpopularMovies, ...populaResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');

    final creditsResponse = CreditResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);

    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      final results = await searchMovies(value);

      _sugestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
