// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_my_kino_app/models/search_tvshow_request.dart';
import 'package:http/http.dart' as http;

import 'movie.dart';
import '../models/search_movie_request.dart';

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
        print('Произошла ошибка при поиске фильмов: $error');
      }
    } else {
      print(response.statusCode);
    }
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
        // print(response);
        if (response.statusCode == 200) {
          //получаем результаты поиска и проходимся по списку, создавая фильмы
          final movieSearch = SearchMovie.fromJson(json.decode(response.body));
          if (movieSearch.results.isNotEmpty) {
            addMoviesInList(movieSearch);
          } else {
            isNotEmptySearch = false;
          }
        } else {
          print(response.statusCode);
        }
      } on SocketException catch (er) {
        print('Произошла ошибка при поиске фильмов: $er');
        rethrow;
      } catch (er) {
        print('Произошла ошибка при поиске фильмов: $er');
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
        print('Произошла ошибка movies/searchTvShow: $error');
      }
    } else {
      print(response.statusCode);
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
          if (tvShowSearch.results.isNotEmpty) {
            addTvShowInList(tvShowSearch);
          }
          // если нет, то выходим из метода
          else {
            isNotEmptySearch = false;
          }
        } else {
          print(response.statusCode);
        }
        notifyListeners();
      } catch (error) {
        print('Произошла ошибка movies/searchTvShow: $error');
      }
    }
  }

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
