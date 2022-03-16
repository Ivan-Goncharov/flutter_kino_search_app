import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../request_querry/movie_info_request.dart';
import '../request_querry/tvshow_info.dart';
import '../request_querry/watch_providers_request.dart';
import '../../providers/movie.dart';
import '../request_querry/credits_info_request.dart';

//класс для получения детальной информации об одном медиа продутке
class DetailsMediaMod {
  // принимает id и date фильма для выполнения поиска
  final int id;
  final String date;
  DetailsMediaMod(
    this.id,
    this.date,
  );

  //описание
  String _overview = '';
  String get overview => _overview;

  //название
  String _title = '';
  String _originalTitle = '';

  //дата последнего эпизода
  String _lastEpisodeDate = '';
  String get lastEpisodeDate => _lastEpisodeDate;

  //список жанров
  String _genres = '';
  String get genres => _genres;

  //различные данные с imdb
  String _imdbId = '';
  String get imdbId => _imdbId;

  String _imdbRat = '';
  String get imdbRat => _imdbRat;

  String _imdbVotes = '';
  String get imdbVotes => _imdbVotes;

  //продолжительность
  String _duration = '';
  String get duration => _duration;

  //возрастные ограничения
  String _ageLimitRu = '';
  String get ageLimitRu => _ageLimitRu;

  String _ageLimitUS = '';
  String get ageLimitUS => _ageLimitUS;

  //ключ ссылки на трейлер
  String _keyVideo = '';
  String get keyVideo => _keyVideo;

  // количество сезонов
  int _numberOfSeasons = 0;
  String numberOfSeasons() {
    if (_numberOfSeasons == 0) {
      return '';
    } else if (_numberOfSeasons == 1) {
      return ', 1 сезон';
    } else if (_numberOfSeasons < 5) {
      return ', $_numberOfSeasons сезона';
    } else {
      return ', $_numberOfSeasons сезонов';
    }
  }

  //информация об актерах и съемочной группе
  CreditsInfoRequest? _creditsInfo;
  CreditsInfoRequest? get creditsInfo => _creditsInfo;

  WatchProvidersRequest? _watchProviders;
  WatchProvidersRequest? get watchProviders => _watchProviders;

  // поиск детальных данных о фильме
  Future getDetailesMovie() async {
    if (id != 0) {
      // ищем по id
      final url = Uri.parse(
          'https://api.themoviedb.org/3/movie/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&append_to_response=credits,release_dates,watch/providers');
      try {
        final response = await http.get(url);
        //обрабатываем запрос
        if (response.statusCode == 200) {
          final _movie = MovieInfoRequest.fromJson(json.decode(response.body));
          _genres = _movie.getGenres();
          _imdbId = _movie.imdbId ?? '';
          _duration = _movie.getDuration();
          _overview = _movie.overview ?? '';
          _title = _movie.title ?? '';
          _originalTitle = _movie.originalTitle ?? '';

          //проходим по списку возрастных ограничений, которые доступны
          final certification = _movie.releaseDates.results ?? [];
          for (var releas in certification) {
            if (releas.iso31661 == 'RU') {
              _ageLimitRu = releas.releaseDates?[0].certification ?? '';
            }
            if (releas.iso31661 == 'US') {
              _ageLimitUS = releas.releaseDates?[0].certification ?? '';
            }
          }
        } else {
          throw SocketException('Connect Error');
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  //загружаем детальные данные о сериале с помощью его ID
  Future getDetailesTVShow() async {
    if (id != 0) {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/tv/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&append_to_response=credits,watch/providers,external_ids');
      try {
        final response = await http.get(url);
        //обрабатываем резульаты запроса
        if (response.statusCode == 200) {
          final tvShow = TvShowDetailsInfo.fromJson(json.decode(response.body));
          _genres = tvShow.getGenres();
          _imdbId = tvShow.externalIds?.imdbId ?? '';
          _overview = tvShow.overview ?? '';
          _title = tvShow.name ?? '';
          _originalTitle = tvShow.originalName ?? '';
          _duration = tvShow.getDuration();
          _lastEpisodeDate = tvShow.getLastEpisodeDate();
          _numberOfSeasons = tvShow.numberOfSeasons;
        } else {
          throw SocketException('Connect Error');
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  //получаем рейтинг IMDB, используя API OMDB
  Future<void> getRating() async {
    if (imdbId != '') {
      final url =
          Uri.parse('http://www.omdbapi.com/?apikey=bcfb41e2&i=$imdbId');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final movieRatings = json.decode(response.body);
          _imdbRat = movieRatings['imdbRating'];

          //проверяем количество оценок, если оно больше тысячи, то разделяем пробелом тысячи
          if ((movieRatings['imdbVotes'] as String).contains(',')) {
            final splitVotes = (movieRatings['imdbVotes'] as String).split(',');
            _imdbVotes = '${splitVotes[0]} ${splitVotes[1]} оценки';
          } else {
            _imdbVotes = '${movieRatings['imdbVotes']} оценки';
          }
        } else {
          throw SocketException('Connect Error');
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  //метод для запроса видео трейлеров фильма
  //принимаем тип медиа, чтобы скорректировать запрос по фильмам или тв
  Future<void> getTrailer(MediaType type) async {
    final mediaType = setStringMediaType(type);

    // сначала делаем запрос по трейлерам на Русском,
    // если такие отсутсвуют, то ищем трейлеры на английском
    trailerCountry('ru', mediaType, _title).then(
      (valueRu) {
        if (valueRu.isEmpty) {
          trailerCountry('us', mediaType, _originalTitle).then(
            (valueUS) {
              _keyVideo = valueUS;
            },
          );
        } else {
          _keyVideo = valueRu;
        }
      },
    );
  }

  //метод для запроса трейлера
  //принимает код страны
  //типа медиа и  id фильма
  Future<String> trailerCountry(
    String codCounty,
    String mediaType,
    String movieTitle,
  ) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/$mediaType/$id/videos?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=$codCounty');
    try {
      final response = await http.get(url);
      var videoKey = '';
      if (response.statusCode == 200) {
        final movieTrailer =
            json.decode(response.body)['results'] as List<dynamic>;
        // обрабатываем результаты
        if (movieTrailer.isNotEmpty) {
          for (int i = 0; i < movieTrailer.length; i++) {
            final video = movieTrailer[i];
            String videoName = video['name'] as String;
            String type = video['type'] as String;
            movieTitle = movieTitle.toLowerCase();
            videoName = videoName.toLowerCase();

            //необходимо, что название видео содержало название фильма
            //и тип был trailer
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
      rethrow;
    }
  }

  //метод для получения данных о съемочной группе и актерах фильма
  Future<void> getMovieCredits() async {
    if (id != 0) {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/movie/$id/credits?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          //обрабтывам резульат с помощью соотвествующей модели
          _creditsInfo =
              CreditsInfoRequest.fromJson(json.decode(response.body));
          //запускаем метод, который создает
          // карту самых важных работников съемочной группы
          _creditsInfo!.createMapCrewMovie();
        } else {
          throw SocketException('Connect false');
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  //метод для получения актерского состава всех сезонов сериала
  Future<void> getTVShowCredits() async {
    if (id != 0) {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/tv/$id/aggregate_credits?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          _creditsInfo =
              CreditsInfoRequest.fromJson(json.decode(response.body));
          _creditsInfo!.createMapCrewMovie();
        } else {
          throw SocketException('Connect false');
        }
      } catch (e) {
        rethrow;
      }
    }
  }

// метод для получения данных о провайдерах, которые показывают фильм в России
  Future<void> getWatchProviders(MediaType type) async {
    final mediaType = setStringMediaType(type);
    if (id != 0) {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/$mediaType/$id/watch/providers?api_key=2115a4e4d0db6b9e7298306e0f3a6817');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          _watchProviders =
              WatchProvidersRequest.fromJson(json.decode(response.body));
        } else {
          throw SocketException('Connect false');
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  // метод для форматирования типа медиа в String
  String setStringMediaType(MediaType type) {
    if (type == MediaType.movie) {
      return 'movie';
    } else if (type == MediaType.tvShow) {
      return 'tv';
    } else {
      return '';
    }
  }
}
