import 'dart:convert';
import '../../providers/movie.dart';
import 'package:http/http.dart' as http;

// класс для получния истории поиска
class MovieHistory {
  //список фильмов
  List<MediaBasicInfo> _historySearch = [];
  List<MediaBasicInfo> get historySearch {
    return _historySearch.reversed.toList();
  }

  final String _userUid;
  MovieHistory(this._userUid);

  // метод для добавления медиа в историю
  // добавляем максимум 11 фильмов, если список больше, то удаляем самый старый фильм ив поиске
  Future<void> addMovie(MediaBasicInfo media) async {
    int index = _historySearch.indexWhere((el) => el.id == media.id);
    if (index == -1) {
      if (_historySearch.length < 11) {
        newNote(media);
      } else {
        deleteAndAddNote().then((_) {
          newNote(media).then((_) {});
        });
      }
    }
  }

  // метод для добавления медиа, если история поиска меньше 11
  Future<void> newNote(MediaBasicInfo media) async {
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/mediaHistory/$_userUid.json',
    );

    try {
      await http.post(
        url,
        body: json.encode({
          'mediaId': media.id,
          'imageUrl': media.imageUrl,
          'title': media.title,
          'originalTitle': media.originalTitle,
          'overview': media.overview,
          'date': media.date,
          'voteCount': media.voteCount,
          'type': getStringType(media.type),
        }),
      );

      _historySearch.add(media);
    } catch (error) {
      throw error;
    }
  }

  // метод для обновления самого старшего фильма в истории поиска на новый
  // если длина списка больше 11
  Future<void> deleteAndAddNote() async {
    // получаем id записи в firebase
    String id = '';
    await searchIndexNote().then((value) {
      id = value;
    });

    //переходим к этой записи
    final getUrl = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/mediaHistory/$_userUid/$id.json',
    );

    // и удаляем ее
    try {
      http.delete(getUrl);
      _historySearch.removeAt(0);
    } catch (error) {
      throw error;
    }
  }

  // метод для получения индекса самой старшей записи
  Future<String> searchIndexNote() async {
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/mediaHistory/$_userUid.json',
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return extractedData.keys.first;
    } catch (error) {
      throw error;
    }
  }

  // получаем историю поиска с firebase
  Future<void> getAndFetchNote() async {
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/mediaHistory/$_userUid.json',
    );
    try {
      final response = await http.get(url);

      final extradata = json.decode(response.body) as Map<String, dynamic>?;
      if (extradata?.isEmpty ?? true) {
        return;
      }
      final List<MediaBasicInfo> loadedMedia = [];
      extradata!.forEach(
        (key, media) {
          loadedMedia.add(
            MediaBasicInfo(
              id: media['mediaId'],
              imageUrl: media['imageUrl'],
              title: media['title'],
              originalTitle: media['originalTitle'],
              overview: media['overview'],
              date: media['date'],
              voteCount: media['voteCount'],
              type: getEnumType(media['type']),
            ),
          );
        },
      );
      _historySearch = loadedMedia;
    } catch (error) {
      rethrow;
    }
  }

  // форматирование типа медиа
  String getStringType(MediaType type) {
    if (type == MediaType.movie) {
      return 'movie';
    } else {
      return 'tvShow';
    }
  }

  MediaType getEnumType(String type) {
    if (type == 'movie') {
      return MediaType.movie;
    } else {
      return MediaType.tvShow;
    }
  }
}
