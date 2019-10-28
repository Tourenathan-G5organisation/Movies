import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:movies/model/Movie.dart';
import 'package:movies/model/Actor.dart';
import 'package:movies/api/movie_api_service.dart';

class NowPlayingMovies with ChangeNotifier {
  List<Movie> _movies;
  bool _isLoading = true; // determines if the we are loading movies or not
  BuildContext _context;
  int _page = 0;
  int _maxPage = 1;
  MovieApiService _movieApiService;

  NowPlayingMovies(BuildContext context) {
    _movies = [];
    _movieApiService = MovieApiService();
    getMoreMovies();
  }

  List<Movie> get movies => _movies;

  set movies(List<Movie> newMovies) {
    _movies.addAll(newMovies);
    notifyListeners();
  }

  bool isLoading() => _isLoading;

  void getMoreMovies() async{
    if (_page < _maxPage) {
      _page++;
      _isLoading = true;
      notifyListeners();
      ApiResponse response = await _movieApiService.getNowPlayingMovies(_page);
      print(response.toString());
      _isLoading = false;
      if (response.hasResponse) {
        _maxPage = response.results["total_pages"] ?? _maxPage;
        List<Movie> loadedMovies = (response.results["results"] as List)
            .map((item) => Movie.fromJson(item))
            .toList();
        movies = loadedMovies;
      } else {
        //if (movies.length == 0) {}
        notifyListeners();
      }
    }
  }

}
