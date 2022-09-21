import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/now_playing_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '1857d2a5d29e3fdfc67803cc372182ee';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'en-US';

  MoviesProvider() {
    print('movies provider inicializado');

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

    print(nowPlayingResponse.results[1].title);
  }
}
