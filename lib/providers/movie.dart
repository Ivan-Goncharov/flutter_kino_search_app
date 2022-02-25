import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/models/credits_info.dart';
import 'package:http/http.dart' as http;

import '../models/movie_info.dart';

//класс - провайдер для создания одного фильма
class Movie with ChangeNotifier {
  int? id;
  String? imageUrl;
  String? title;
  String? originalTitle;
  String? overview;
  String? date;
  int? voteCount;

  //данные переменные будут заполняться по мере выолнения запросов API
  String genres = '';
  String imdbId = '';
  String duration = '';
  String imdbRat = '';
  String imdbVotes = '';
  String ageLimitRu = '';
  String ageLimitUS = '';
  String keyVideo = '';
  CreditsMovieInfo? creditsInfo;

  Movie({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.date,
    required this.voteCount,
  });

  //загружаем детальные данные о фильме с помощью его ID
  Future detailedMovie() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');

    print(id);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final _movie = MovieInfo.fromJson(json.decode(response.body));
        genres = _movie.getGenres();
        imdbId = _movie.imdbId as String;
        duration = _movie.getDuration();
      } else {
        print('Что-то пошло не так');
      }
    } catch (e) {
      if (e is SocketException) {
        print("Socket exception: ${e.toString()}");
        rethrow;
        // rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
  }

  //получаем рейтинг IMDB, используя API OMDB
  Future getRating() async {
    final url = Uri.parse('http://www.omdbapi.com/?apikey=bcfb41e2&i=$imdbId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final movieRatings = json.decode(response.body);
        imdbRat = movieRatings['imdbRating'];

        //проверяем количество оценок, если оно больше тысячи, то разделяем пробелом тысячи
        if ((movieRatings['imdbVotes'] as String).contains(',')) {
          final splitVotes = (movieRatings['imdbVotes'] as String).split(',');
          imdbVotes = '${splitVotes[0]} ${splitVotes[1]} оценки';
        } else {
          imdbVotes = '${movieRatings['imdbVotes']} оценки';
        }
      }
    } catch (e) {
      if (e is SocketException) {
        print("Socket exception: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
  }

  //метод для запроса возрастных ограничений фильма
  Future getCertification() async {
    try {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/movie/$id/release_dates?api_key=2115a4e4d0db6b9e7298306e0f3a6817');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final movieCertif =
            json.decode(response.body)['results'] as List<dynamic>;
        //проходим по списку сертификатов и ищем
        //есть ли русская и американская сертификации
        for (int i = 0; i < movieCertif.length; i++) {
          if (movieCertif[i]['iso_3166_1'] == 'RU') {
            ageLimitRu = movieCertif[i]['release_dates'][0]['certification'];
          }
          if (movieCertif[i]['iso_3166_1'] == 'US') {
            ageLimitUS = movieCertif[i]['release_dates'][0]['certification'];
          }
        }
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
  }

  //метод для запроса видео трейлеров фильма
  void getTrailer() {
    trailerCountry('ru', '$title').then(
      (valueRu) {
        if (valueRu.isEmpty) {
          trailerCountry('us', '$originalTitle').then(
            (valueUS) {
              keyVideo = valueUS;
            },
          );
        } else {
          keyVideo = valueRu;
        }
      },
    );
  }

  Future<String> trailerCountry(String codCounty, String movieTitle) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/videos?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=$codCounty');
    try {
      final response = await http.get(url);
      var videoKey = '';
      if (response.statusCode == 200) {
        final movieTrailer =
            json.decode(response.body)['results'] as List<dynamic>;
        if (movieTrailer.isNotEmpty) {
          for (int i = 0; i < movieTrailer.length; i++) {
            final video = movieTrailer[i];
            String videoName = video['name'] as String;
            String type = video['type'] as String;
            movieTitle = movieTitle.toLowerCase();
            videoName = videoName.toLowerCase();

            if (videoName.contains(movieTitle) && type == 'Trailer') {
              videoKey = video['key'];
              break;
            }
          }
        }
        return videoKey;
      } else {
        return videoKey;
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
    return '';
  }

  Future<void> getMovieCredits() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/credits?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        creditsInfo = CreditsMovieInfo.fromJson(json.decode(response.body));
        print(creditsInfo?.cast[0].name);
      }
    } catch (e) {
      if (e is SocketException) {
        print("Socket exception: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
  }
}
