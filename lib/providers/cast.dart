import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:http/http.dart' as http;

class ItemCastInfo {
  final int id;
  ItemCastInfo(this.id);

  String _birthday = '';
  String get birthday {
    return _birthday;
  }

  Map<String, List<MediaBasicInfo>> _mapMovies = {};
  Map<String, List<MediaBasicInfo>> get mapMovies {
    return _mapMovies;
  }

  int _age = 0;
  String get age {
    int remaind = _age % 10;
    if (remaind > 1 && remaind < 5 && _age > 20) {
      return '$_age года';
    } else if (remaind == 1 && _age > 20) {
      return '$_age год';
    } else {
      return '$_age лет';
    }
  }

  String _deathday = '';
  String get deathday {
    return _deathday;
  }

  Future getCastInfo() async {
    try {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/person/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final castInfo = json.decode(response.body);
        _getFormatDate(castInfo['birthday'], castInfo['deathday']);
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception in cast/getCastInfo: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception in cast/getCastInfo: ${e.toString()}");
      } else
        print("Unhandled exception in cast/getCastInfo: ${e.toString()}");
    }
  }

//
  void _getFormatDate(String? castBirthDate, String? castDeathDate) {
    initializeDateFormatting('ru');
    DateFormat dateFormat = DateFormat.yMMMMd('ru');
    DateTime dateTimeBirth = DateTime.now();
    DateTime dateTimeDeath = DateTime.now();
    if (castBirthDate != null) {
      dateTimeBirth = DateFormat('yyyy-MM-dd').parse(castBirthDate);
      _birthday = dateFormat.format(dateTimeBirth);
    }

    if (castDeathDate != null) {
      dateTimeDeath = DateFormat('yyyy-MM-dd').parse(castDeathDate);
      _deathday = dateFormat.format(dateTimeDeath);
    }

    _age = yearsBetween(dateTimeBirth, dateTimeDeath);
  }

  int yearsBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    int def = to.difference(from).inHours;
    return (def / 8766).floor();
  }

  Future getMovieInfo() async {
    try {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/person/$id/movie_credits?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        _mapMovies = {
          'Актер': addListMovie(result['cast']),
          'Съемочная группа': addListMovie(result['crew'])
        };
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception in cast/getMovieInfo: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception in cast/getMovieInfo: ${e.toString()}");
      } else
        print("Unhandled exception in cast/getMovieInfo: ${e.toString()}");
    }
  }

  List<MediaBasicInfo> addListMovie(List<dynamic> list) {
    final List<MediaBasicInfo> listMovies = [];
    if (list.isNotEmpty) {
      for (int a = 0; a < list.length; a++) {
        final movie = list[a];
        final isContain =
            listMovies.indexWhere((element) => element.id == movie['id']);
        if (isContain == -1) {
          listMovies.add(
            MediaBasicInfo(
              id: movie['id'],
              imageUrl: movie['poster_path'] ?? "assets/image/noImageFound.png",
              title: movie['title'] ?? '',
              originalTitle: movie['original_title'] ?? '',
              overview: movie['overview'] ?? '',
              date: getMovieDate(movie['release_date'] as String?),
              voteCount: movie['vote_count'] ?? 0,
              type: MediaType.movie,
            ),
          );
        }
      }
    }
    return listMovies;
  }

  String getMovieDate(String? date) {
    if (date != null && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
  }
}
