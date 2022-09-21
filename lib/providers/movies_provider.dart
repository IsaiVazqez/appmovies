import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/now_playing_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '1857d2a5d29e3fdfc67803cc372182ee';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];

  MoviesProvider() {
    // ignore: avoid_print
    print('movies provider inicializado');

    // ignore: unnecessary_this
    this.getOnDisplaymovies();
  }

  getOnDisplaymovies() async {
    var url = Uri.https(_baseUrl, '/3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

    var response = await http.get(url);

    final nowPlayingResponse = NowPlayingResponse.fromJson(response.body);

    // ignore: avoid_print
    print(nowPlayingResponse.results[1].title);

    onDisplayMovies = [...nowPlayingResponse.results];

    notifyListeners();
  }
}
