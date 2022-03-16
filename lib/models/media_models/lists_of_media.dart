import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_my_kino_app/providers/movie.dart';

//класс для обработки запросов с популярными  и трендовыми фильмами
class ListsOfMedia {
  List<MediaBasicInfo> _popularMovies = [];
  List<MediaBasicInfo> get popularMovies => _popularMovies;

  List<MediaBasicInfo> _topRatedMovies = [];
  List<MediaBasicInfo> get topRatedMovies => _topRatedMovies;

  List<MediaBasicInfo> _nowPlayMovies = [];
  List<MediaBasicInfo> get nowPlayMovies => _nowPlayMovies;

  List<MediaBasicInfo> _upcomingMovies = [];
  List<MediaBasicInfo> get upcommingMovies => _upcomingMovies;

  List<MediaBasicInfo> _popularTvShows = [];
  List<MediaBasicInfo> get popularTvShows => _popularTvShows;

  List<MediaBasicInfo> _topRatedTvShow = [];
  List<MediaBasicInfo> get topRatedTvShow => _topRatedTvShow;

  //запрашиваем списки фильмов  и сериалов поочереди
  Future<bool> requestMediaLists() async {
    try {
      //делаем 6 запросов синхронно и ждем результат
      await Future.wait([
        getListOfMedia(listType: 'popular', mediaType: 'movie'),
        getListOfMedia(listType: 'now_playing', mediaType: 'movie'),
        getListOfMedia(listType: 'upcoming', mediaType: 'movie'),
        getListOfMedia(listType: 'top_rated', mediaType: 'movie'),
        getListOfMedia(listType: 'popular', mediaType: 'tv'),
        getListOfMedia(listType: 'top_rated', mediaType: 'tv'),
      ]).then((value) {
        _popularMovies = value[0];
        _nowPlayMovies = value[1];
        _upcomingMovies = value[2];
        _topRatedMovies = value[3];
        _popularTvShows = value[4];
        _topRatedTvShow = value[5];
      });

      return true;
      //если ошибка, то возвращаем false, чтобы обработать запрос
    } catch (e) {
      return false;
    }
  }

  //метод для  Api запроса, который возвращает список медиа
  //принимает тип медиа и тип списка  для соотвествуюещго запроса в api
  Future<List<MediaBasicInfo>> getListOfMedia(
      {required String listType, required String mediaType}) async {
    var page = 0;
    var isSearch = true;
    List<MediaBasicInfo> list = [];
    while (isSearch) {
      page++;
      try {
        final url = Uri.parse(
            'https://api.themoviedb.org/3/$mediaType/$listType?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=$page');

        final response = await http.get(url);
        if (response.statusCode == 200) {
          //обрабатываем результат
          final listMedia =
              json.decode(response.body)['results'] as List<dynamic>;

          // если есть список с TMDB не пустой и
          // мы еще не заполнили наш список на 20 позиций,
          // то обрабатываем полученные данные
          if (listMedia.isNotEmpty && list.length < 20) {
            //если тип TV, то обрабатываем данные метод для TV
            if (mediaType == 'tv') {
              list.addAll(_addTVShows(listMedia));

              //если типа списка фильмов - top,
              // то вызываем соотвествующий метод
            } else if (listType == 'top_rated') {
              list.addAll(_addBestMoviesList(listMedia));

              //для остальных списков фильмов
            } else {
              list.addAll(_addElementsInList(listMedia));
            }

            //если заполнили список или запрос пустой, то выходим из while
          } else {
            isSearch = false;
          }
        }

        //обрабатываем ошибки
      } catch (e) {
        rethrow;
      }
    }
    return list;
  }

  //метод для поиска результатов по жанрам
  // принимает жанр и тип медиа
  Future<List<MediaBasicInfo>?> getListOfGenres(
      {required int genre, required mediaType}) async {
    //список для записи медиа
    List<MediaBasicInfo>? list = [];

    //переменная, которая ограничивает количество найденных сериалов и фильмов
    int maxLenght = mediaType == 'tv' ? 20 : 30;

    //флаг для прекрщаения поиска поле 30 фильмов
    bool _isSearch = true;
    int page = 0;

    //ищем фильмы с соотвествующим жанром в разделе топ фильмов,
    //пока не закончится список или не наберется 30 фильмов
    while (_isSearch) {
      page++;
      final url = Uri.parse(
          'https://api.themoviedb.org/3/$mediaType/top_rated?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=$page');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final listMedia =
              json.decode(response.body)['results'] as List<dynamic>;

          if (listMedia.isNotEmpty && list!.length < maxLenght) {
            if (mediaType == 'tv') {
              for (var tvShow in listMedia) {
                //задаем условия и жанр, по которым сериал попадет список
                //если все совпадает - то добавляем сериал в список
                final listGenres = tvShow['genre_ids'] as List<dynamic>;
                final voteCount = tvShow['vote_count'];
                final country = tvShow['origin_country'] as List<dynamic>;
                if (listGenres.contains(genre) &&
                    !country.contains('JP') &&
                    !country.contains('CH') &&
                    !country.contains('TH') &&
                    voteCount > 1000) {
                  print(tvShow['name']);
                  print(list.length);
                  list.add(createSingleMedia(tvShow, false));
                }
              }
            } else {
              for (var movie in listMedia) {
                //если список жанров фильма содержит соотвествующий id,
                // то здобавляем фильм в список
                final listGenres = movie['genre_ids'] as List<dynamic>;
                final voteCount = movie['vote_count'];
                if (listGenres.contains(genre) && voteCount > 2000) {
                  list.add(createSingleMedia(movie, true));
                }
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
      listMovies.add(createSingleMedia(movie, true));
    }
    return listMovies;
  }

  // метод для создания списка лучших фильмов с фильтрацией количества оценок
  List<MediaBasicInfo> _addBestMoviesList(List<dynamic> list) {
    final List<MediaBasicInfo> listMovies = [];
    for (var movie in list) {
      final voteCount = movie['vote_count'];
      if (voteCount > 2000) {
        listMovies.add(createSingleMedia(movie, true));
      }
    }
    return listMovies;
  }

  // обрабатывает запись и создает экземпляр одного медиа
  MediaBasicInfo createSingleMedia(dynamic media, bool isMovie) {
    return MediaBasicInfo(
      id: media['id'],
      imageUrl: media['poster_path'] ?? "assets/image/noImageFound.png",
      title: isMovie ? media['title'] : media['name'],
      originalTitle: isMovie ? media['original_title'] : media['original_name'],
      overview: media['override'],
      date: _getMovieDate(
          isMovie ? media['release_date'] : media['first_air_date']),
      voteCount: media['vote_count'],
      type: isMovie ? MediaType.movie : MediaType.tvShow,
    );
  }

  //форматирует дату создания до года, если даты нет,
  // то возврщаем пустую строку
  String _getMovieDate(String? date) {
    if (date != null && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
  }

  //метод для обработки списка сериалов с json резульата
  List<MediaBasicInfo> _addTVShows(List<dynamic> list) {
    final List<MediaBasicInfo> listOfTvShow = [];
    for (var tvShow in list) {
      final country = tvShow['origin_country'] as List<dynamic>;
      if (!country.contains('JP') &&
          !country.contains('CH') &&
          !country.contains('TH') &&
          tvShow['vote_count'] > 2000) {
        listOfTvShow.add(createSingleMedia(tvShow, false));
      }
    }
    return listOfTvShow;
  }
}
