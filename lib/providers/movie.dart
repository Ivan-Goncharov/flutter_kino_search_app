import 'dart:convert';

import 'package:flutter/material.dart';
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

  //данные переменные будут заполняться по мере выолнения запросов API
  String genres = '';
  String imdbId = '';
  String duration = '';
  String imdbRat = '';
  String imdbVotes = '';
  String ageLimitRu = '';
  String ageLimitUS = '';

  Movie({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.date,
  });

  //загружаем детальные данные о фильме с помощью его ID
  Future detailedMovie() async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
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
    } catch (error) {
      print(error);
    }
  }

  //получаем рейтинг IMDB, используя API OMDB
  Future getRating() async {
    final url = Uri.parse('http://www.omdbapi.com/?apikey=bcfb41e2&i=$imdbId');
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
  }

  //метод для запроса возрастных ограничений фильма
  Future getCertification() async {
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
  }
}
