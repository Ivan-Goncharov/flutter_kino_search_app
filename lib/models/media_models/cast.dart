import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

import '../../providers/movie.dart';

//класс для получения детальной информации об артисте
class ItemCastInfo {
  //принимаем id артиста
  final int id;
  ItemCastInfo(this.id);

  //переменная для даты рождения
  String _birthday = '';
  String get birthday {
    return _birthday;
  }

  //дата смерти
  String _deathday = '';
  String get deathday {
    return _deathday;
  }

  //список фильмов в виде карты
  //ключ - в каком качестве принимал участие в съемках
  //значение - список фильмов
  Map<String, List<MediaBasicInfo>> _mapOfMedia = {};
  Map<String, List<MediaBasicInfo>> get mapOfMedia {
    return _mapOfMedia;
  }

  //переменная для корректного возвращения возраста
  int _age = 0;
  String get age {
    int remaind = _age % 10;
    if (remaind > 1 && remaind < 5 && _age > 20) {
      return '$_age года';
    } else if (remaind == 1 && _age > 20) {
      return '$_age год';
    } else if (_age > 0) {
      return '$_age лет';
    } else {
      return '';
    }
  }

  //получаем детальную информацию
  Future<bool> getCastInfo() async {
    try {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/person/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final castInfo = json.decode(response.body);

        //обрабатываем дату рождения и смерти
        _getFormatDate(castInfo['birthday'], castInfo['deathday']);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

// метод для форматирования дат смерти и рождения
// и вычисления возраста
  void _getFormatDate(String? castBirthDate, String? castDeathDate) {
    //русский формат даты
    initializeDateFormatting('ru');
    DateFormat dateFormat = DateFormat.yMMMMd('ru');
    DateTime dateTimeBirth = DateTime.now();
    DateTime dateTimeDeath = DateTime.now();

    //дата рождения в нужном формате
    if (castBirthDate != null) {
      dateTimeBirth = DateFormat('yyyy-MM-dd').parse(castBirthDate);
      _birthday = dateFormat.format(dateTimeBirth);
    }

    //дата смерти
    if (castDeathDate != null) {
      dateTimeDeath = DateFormat('yyyy-MM-dd').parse(castDeathDate);
      _deathday = dateFormat.format(dateTimeDeath);
    }

    _age = yearsBetween(dateTimeBirth, dateTimeDeath);
  }

  //вычисления возраста методом нахождения разницы между датами
  int yearsBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    int def = to.difference(from).inHours;
    return (def / 8766).floor();
  }

  //метод находит фильмы, в которых принимал участие артист
  Future<bool> getMovieInfo() async {
    try {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/person/$id/combined_credits?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        //заполняем карту
        _mapOfMedia = {
          'Актер': addMediaMovie(result['cast']),
          'Съемочная группа': addMediaMovie(result['crew'])
        };
        return true;
      } else {
        throw SocketException('Connect false');
      }
    } catch (e) {
      return false;
    }
  }

  //метод для создания списка фильмов на основе json запроса
  List<MediaBasicInfo> addMediaMovie(List<dynamic> list) {
    final List<MediaBasicInfo> listMovies = [];
    if (list.isNotEmpty) {
      for (int a = 0; a < list.length; a++) {
        final media = list[a];

        //проверяем - не записывали ли уже данный фильм
        // так как есть дубликаты и артист принимает участие
        //в одном фильме одновременно на нескольких ролях
        final isContain =
            listMovies.indexWhere((element) => element.id == media['id']);

        if (isContain == -1) {
          //проверяем тип записи, так как разные ключи к данным у сериалов и фильмов
          final _isTvShow = media['media_type'] == 'tv';

          listMovies.add(
            MediaBasicInfo(
              id: media['id'],
              imageUrl: media['poster_path'] ?? "assets/image/noImageFound.png",
              title: _isTvShow ? media['name'] ?? '' : media['title'] ?? '',
              originalTitle: _isTvShow
                  ? media['original_name'] ?? ''
                  : media['original_title'] ?? '',
              overview: media['overview'] ?? '',
              date: _isTvShow
                  ? getMovieDate(media['first_air_date'] as String?)
                  : getMovieDate(media['release_date'] as String?),
              voteCount: media['vote_count'] ?? 0,
              type: _isTvShow ? MediaType.tvShow : MediaType.movie,
            ),
          );
        }
      }
    }
    return listMovies;
  }

  //форматирование даты
  String getMovieDate(String? date) {
    if (date != null && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
  }
}
