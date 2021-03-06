import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/request_querry/search_tvshow_request.dart';
import 'movie.dart';
import '../models/request_querry/search_movie_request.dart';

//класс провайдер для создания списка фильмов в поиске
class Movies with ChangeNotifier {
  //список фильмов
  List<MediaBasicInfo> _itemsMovies = [];
  //сортируем по популярности и возвращаем список фильмов
  List<MediaBasicInfo> get itemsMovies {
    _itemsMovies.sort(
      (a, b) => b.voteCount!.compareTo(a.voteCount as int),
    );
    return _itemsMovies;
  }

  setItemsMovie() {
    _itemsMovies = [];
    notifyListeners();
  }

  // список актеров
  List<MediaBasicInfo> _itemsTVshows = [];
  //сортируем по популярности и возвращаем список сериалов
  List<MediaBasicInfo> get itemsTVshows {
    _itemsTVshows.sort(
      (a, b) => b.voteCount!.compareTo(a.voteCount as int),
    );
    return [..._itemsTVshows];
  }

  setItemsTVshows() {
    _itemsTVshows = [];
    notifyListeners();
  }

  //метод для поиска фильмов
  Future searchMovie({required String name}) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&query=${Uri.encodeFull(name)}&page=1&include_adult=false');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _itemsMovies = [];
      try {
        //получаем результаты поиска и проходимся по списку, создавая фильмы
        final movieSearch = SearchMovie.fromJson(json.decode(response.body));
        if (movieSearch.results.isNotEmpty) {
          addMoviesInList(movieSearch);
        }
      } catch (error) {
        rethrow;
      }
    } else {}
    notifyListeners();
  }

  // метод для поиска всех фильмов возможных фильмов по этому слову
  Future searchAllMovie(String name) async {
    _itemsMovies = [];
    var isNotEmptySearch = true;
    var page = 0;
    while (isNotEmptySearch) {
      page += 1;
      try {
        final response = await http.get(
          Uri.parse(
              'https://api.themoviedb.org/3/search/movie?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&query=${Uri.encodeFull(name)}&page=$page&include_adult=false'),
        );
        if (response.statusCode == 200) {
          //получаем результаты поиска и проходимся по списку, создавая фильмы
          final movieSearch = SearchMovie.fromJson(json.decode(response.body));
          if (movieSearch.results.isNotEmpty && _itemsMovies.length < 30) {
            addMoviesInList(movieSearch);
          } else {
            isNotEmptySearch = false;
          }
        } else {
          throw const SocketException('Connect error');
        }
      } catch (er) {
        rethrow;
      }
    }
  }

// метод для добавления фильмов в список
  void addMoviesInList(SearchMovie search) {
    for (int i = 0; i < search.results.length; i++) {
      final movieItem = search.results[i];
      _itemsMovies.add(
        MediaBasicInfo(
          id: movieItem.id,
          // imageUrl: 'assets/image/noImageFound.png',
          imageUrl: movieItem.posterPath == null
              ? "assets/image/noImageFound.png"
              : "${movieItem.posterPath}",
          title: movieItem.title ?? '',
          originalTitle: movieItem.originalTitle ?? '',
          overview: movieItem.overview ?? '',
          date: getMovieDate(movieItem.releaseDate),
          voteCount: movieItem.voteCount,
          type: MediaType.movie,
        ),
      );
    }
  }

// поиск сериалов
  Future searchTVShow({required String name}) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=1&query=${Uri.encodeFull(name)}&include_adult=false');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      _itemsTVshows = [];
      try {
        //получаем результаты поиска и проходимся по списку, создавая сериалы
        final tvShowSearch =
            SearchTVShowModel.fromJson(json.decode(response.body));
        if (tvShowSearch.results.isNotEmpty) {
          addTvShowInList(tvShowSearch);
        }
      } catch (error) {
        rethrow;
      }
    }
    notifyListeners();
  }

  //поиск всех ТВ ШОУ
  Future searchAllTVShow({required String name}) async {
    _itemsTVshows = [];
    var isNotEmptySearch = true;
    var page = 0;

    while (isNotEmptySearch) {
      page += 1;
      try {
        final url = Uri.parse(
            'https://api.themoviedb.org/3/search/tv?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=$page&query=${Uri.encodeFull(name)}&include_adult=false');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          //получаем результаты поиска и проходимся по списку, создавая сериалы
          final tvShowSearch =
              SearchTVShowModel.fromJson(json.decode(response.body));

          //если список содержит результаты, то добавляем их в лист
          if (tvShowSearch.results.isNotEmpty && _itemsMovies.length < 30) {
            addTvShowInList(tvShowSearch);
          }
          // если нет, то выходим из метода
          else {
            isNotEmptySearch = false;
          }
        }
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

// метод для обработки результатов поиска
  void addTvShowInList(SearchTVShowModel search) {
    for (int i = 0; i < search.results.length; i++) {
      final show = search.results[i];
      _itemsTVshows.add(
        MediaBasicInfo(
          id: show.id,
          imageUrl: show.posterPath == null
              ? "assets/image/noImageFound.png"
              : "${show.posterPath}",
          title: show.name ?? '',
          originalTitle: show.originalName ?? '',
          overview: show.overview ?? '',
          date: getMovieDate(show.firstAirDate),
          voteCount: show.voteCount,
          type: MediaType.tvShow,
        ),
      );
    }
  }

  //метод для редактирования даты
  // проверяем, чтобы поле было не пустым
  String getMovieDate(String? date) {
    if (date != null && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
  }
}
