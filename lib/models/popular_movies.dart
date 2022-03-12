// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter_my_kino_app/providers/movie.dart';

//класс для обработки запросов с популярными  и трендовыми фильмами
class PopularMovies {
  List<MediaBasicInfo> _popularMovies = [];
  List<MediaBasicInfo> get popularMovies => _popularMovies;

  List<MediaBasicInfo> _topRatedMovies = [];
  List<MediaBasicInfo> get topRatedMovies => _topRatedMovies;

  List<MediaBasicInfo> _nowPlayMovies = [];
  List<MediaBasicInfo> get nowPlayMovies => _nowPlayMovies;

  List<MediaBasicInfo> _upcomingMovies = [];
  List<MediaBasicInfo> get upcommingMovies => _upcomingMovies;

  //метод для запроса самых популярных фильмов с tmdb
  //принимает адресс запроса для соотвествуюещго запроса в api
  Future<List<MediaBasicInfo>> getPopularMovie({required String adress}) async {
    final url = Uri.parse(adress);
    List<MediaBasicInfo> list = [];
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        //обрабатываем результат
        final lisMovies =
            json.decode(response.body)['results'] as List<dynamic>;

        // если есть фильмы в запросе, то добавляем их в список
        if (lisMovies.isNotEmpty) {
          list = _addElementsInList(lisMovies);
        }
      }
      return list;
      //обрабатываем ошибки
    } catch (e) {
      if (e is SocketException) {
        print(
            "Socket exception in PopularMovies/getPopularMovie: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        print(
            "Timeout exception in PopularMovies/getPopularMovie: ${e.toString()}");
        rethrow;
      } else {
        print(
            "Unhandled exception in PopularMovies/getPopularMovie: ${e.toString()}");
        rethrow;
      }
    }
  }

  //запрашиваем списки фильмов поочереди
  Future<bool> requestMovies() async {
    try {
      //популярные фильмы
      await getPopularMovie(
              adress:
                  'https://api.themoviedb.org/3/movie/popular?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=1')
          .then((value) => _popularMovies = value);

      //сейчас смотрят в кино
      await getPopularMovie(
              adress:
                  'https://api.themoviedb.org/3/movie/now_playing?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=1')
          .then((value) => _nowPlayMovies = value);

      //скоро в кино
      await getPopularMovie(
              adress:
                  'https://api.themoviedb.org/3/movie/upcoming?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=1')
          .then((value) => _upcomingMovies = value);

      //самые рейтинговые фильмы
      await getPopularMovie(
              adress:
                  'https://api.themoviedb.org/3/movie/top_rated?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=1')
          .then((value) => _topRatedMovies = value);
      return true;

      //если ошибка, то возвращаем false, чтобы обработать запрос
    } catch (e) {
      if (e is SocketException) {
        print(
            "Socket exception in PopularMovies/requestMovies: ${e.toString()}");
        return false;
      } else if (e is TimeoutException) {
        print(
            "Timeout exception in PopularMovies/requestMovies: ${e.toString()}");
        return false;
      } else {
        print(
            "Unhandled exception in PopularMovies/requestMovies: ${e.toString()}");
        return false;
      }
    }
  }

  //метод для поиска резульатов по жанрам
  // принимает жанр
  Future<List<MediaBasicInfo>?> getListOfGenres({required int genre}) async {
    List<MediaBasicInfo>? list = [];

    //флаг для прекрщаения поиска поле 30 фильмов
    bool _isSearch = true;
    int page = 0;

    //ищем фильмы с соотвествующим жанром в разделе топ фильмов,
    //пока не закончится список или не наберется 30 фильмов
    while (_isSearch) {
      page++;
      final url = Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=$page');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final lisMovies =
              json.decode(response.body)['results'] as List<dynamic>;

          if (lisMovies.isNotEmpty && list!.length < 30) {
            for (var movie in lisMovies) {
              //если список жанров фильма содержит соотвествующий id,
              // то здобавляем фильм в список
              final listGenres = movie['genre_ids'] as List<dynamic>;
              if (listGenres.contains(genre)) {
                list.add(
                  MediaBasicInfo(
                    id: movie['id'],
                    imageUrl:
                        movie['poster_path'] ?? "assets/image/noImageFound.png",
                    title: movie['title'],
                    originalTitle: movie['original_title'],
                    overview: movie[override],
                    date: _getMovieDate(movie['release_date']),
                    voteCount: movie['vote_count'],
                    type: MediaType.movie,
                  ),
                );
              }
            }
          } else {
            _isSearch = false;
          }
        }
      } catch (e) {
        list = null;
        break;
      }
    }
    return list;
  }

  // метод для создания списка фильмов на основе результатов запроса
  List<MediaBasicInfo> _addElementsInList(List<dynamic> list) {
    final List<MediaBasicInfo> listMovies = [];
    for (var movie in list) {
      listMovies.add(
        MediaBasicInfo(
          id: movie['id'],
          imageUrl: movie['poster_path'] ?? "assets/image/noImageFound.png",
          title: movie['title'],
          originalTitle: movie['original_title'],
          overview: movie[override],
          date: _getMovieDate(movie['release_date']),
          voteCount: movie['vote_count'],
          type: MediaType.movie,
        ),
      );
    }
    return listMovies;
  }

  //метод для вывода фильмов
  String _getMovieDate(String? date) {
    if (date != null && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
  }
}
