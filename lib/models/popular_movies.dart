// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
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
  Future<List<MediaBasicInfo>> getListOfMovies({required String type}) async {
    var page = 0;
    var isSearch = true;
    List<MediaBasicInfo> list = [];
    while (isSearch) {
      page++;
      try {
        final url = Uri.parse(
            'https://api.themoviedb.org/3/movie/$type?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=$page');

        final response = await http.get(url);
        if (response.statusCode == 200) {
          //обрабатываем результат
          final lisMovies =
              json.decode(response.body)['results'] as List<dynamic>;

          // если есть фильмы в запросе, то добавляем их в список
          if (lisMovies.isNotEmpty && list.length < 20) {
            // если заполняем список лучших фильмов,
            //то вызываем метод с фильтрацией по популярности
            if (type == 'top_rated') {
              list.addAll(_addBestMoviesList(lisMovies));
            } else {
              list.addAll(_addElementsInList(lisMovies));
            }
          } else {
            isSearch = false;
          }
        }

        //обрабатываем ошибки
      } catch (e) {
        "Unhandled exception in PopularMovies/getPopularMovie: ${e.toString()}";
        rethrow;
      }
    }
    return list;
  }

  //запрашиваем списки фильмов поочереди
  Future<bool> requestMovies() async {
    try {
      //делаем 4 запроса синхронно и ждем результат
      await Future.wait([
        getListOfMovies(type: 'popular'),
        getListOfMovies(type: 'now_playing'),
        getListOfMovies(type: 'upcoming'),
        getListOfMovies(type: 'top_rated'),
      ]).then((value) {
        _popularMovies = value[0];
        _nowPlayMovies = value[1];
        _upcomingMovies = value[2];
        _topRatedMovies = value[3];
      });

      return true;
      //если ошибка, то возвращаем false, чтобы обработать запрос
    } catch (e) {
      print(
          "Unhandled exception in PopularMovies/requestMovies: ${e.toString()}");
      return false;
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
              final voteCount = movie['vote_count'];
              if (listGenres.contains(genre) && voteCount > 2000) {
                list.add(
                  MediaBasicInfo(
                    id: movie['id'],
                    imageUrl:
                        movie['poster_path'] ?? "assets/image/noImageFound.png",
                    title: movie['title'],
                    originalTitle: movie['original_title'],
                    overview: movie[override],
                    date: _getMovieDate(movie['release_date']),
                    voteCount: voteCount,
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

  // метод для создания списка лучших фильмов с фильтрацией количества оценок
  List<MediaBasicInfo> _addBestMoviesList(List<dynamic> list) {
    final List<MediaBasicInfo> listMovies = [];
    for (var movie in list) {
      final voteCount = movie['vote_count'];
      if (voteCount > 2000) {
        listMovies.add(
          MediaBasicInfo(
            id: movie['id'],
            imageUrl: movie['poster_path'] ?? "assets/image/noImageFound.png",
            title: movie['title'],
            originalTitle: movie['original_title'],
            overview: movie[override],
            date: _getMovieDate(movie['release_date']),
            voteCount: voteCount,
            type: MediaType.movie,
          ),
        );
      }
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
