// ignore_for_file: avoid_print

import 'dart:convert';

import '../providers/movie.dart';
import 'package:http/http.dart' as http;

class PopularTvShowsModel {
  List<MediaBasicInfo> _popularTvShows = [];
  List<MediaBasicInfo> get popularTvShows => _popularTvShows;

  List<MediaBasicInfo> _topRatedTvShow = [];
  List<MediaBasicInfo> get topRatedTvShow => _topRatedTvShow;

  //метод для запросов информации о списках сериалов с tmdb
  //принимает адресс запроса для соотвествуюещго запроса в api
  Future<List<MediaBasicInfo>> _getTvShowList({required String type}) async {
    var page = 0;
    var isSearch = true;
    List<MediaBasicInfo> list = [];
    while (isSearch) {
      page++;
      try {
        final url = Uri.parse(
            'https://api.themoviedb.org/3/tv/$type?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&page=$page');
        final response = await http.get(url);
        if (response.statusCode == 200) {
          //обрабатываем результат
          final listTvShow =
              json.decode(response.body)['results'] as List<dynamic>;

          // если есть сериалы в запросе, то добавляем их в список
          if (listTvShow.isNotEmpty && list.length < 20) {
            for (var tvShow in listTvShow) {
              final country = tvShow['origin_country'] as List<dynamic>;
              final popularity = tvShow['popularity'];
              if (!country.contains('JP') &&
                  !country.contains('CH') &&
                  !country.contains('TH') &&
                  tvShow['vote_count'] > 2000) {
                list.add(
                  MediaBasicInfo(
                    id: tvShow['id'],
                    imageUrl: tvShow['poster_path'] ??
                        "assets/image/noImageFound.png",
                    title: tvShow['name'],
                    originalTitle: tvShow['original_name'],
                    overview: tvShow[override],
                    date: _getTvShowDate(tvShow['first_air_date']),
                    voteCount: tvShow['vote_count'],
                    type: MediaType.tvShow,
                  ),
                );
              }
            }
          } else {
            isSearch = false;
          }
        }

        //обрабатываем ошибки
      } catch (e) {
        "Unhandled exception in PopularTvShow/gettvShowList: ${e.toString()}";
        rethrow;
      }
    }
    return list;
  }

  //метод для форматирования даты в формат года
  String _getTvShowDate(String? date) {
    if (date != null && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
  }

  //запрашиваем списки сериалов поочереди
  Future<bool> requestTVShows() async {
    try {
      //делаем два запроса
      //первый возвращает популярные фильмы,
      //второй - рейтинговые
      await Future.wait([
        _getTvShowList(type: 'popular'),
        _getTvShowList(type: 'top_rated'),
      ]).then((value) {
        _popularTvShows = value[0];
        _topRatedTvShow = value[1];
      });

      return true;
      //если ошибка, то возвращаем false, чтобы обработать запрос
    } catch (e) {
      print(
          "Unhandled exception in PopularMovies/requestMovies: ${e.toString()}");
      return false;
    }
  }
}
