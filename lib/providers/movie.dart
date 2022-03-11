// ignore_for_file: use_rethrow_when_possible, avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//класс - провайдер для создания одного фильма
class MediaBasicInfo with ChangeNotifier {
  int? id;
  String? imageUrl;
  String? title;
  String? originalTitle;
  String? overview;
  String? date;
  int? voteCount;
  MediaType type;

  MediaBasicInfo({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.date,
    required this.voteCount,
    required this.type,
  });

  final _userUid = FirebaseAuth.instance.currentUser?.uid;

  // по умолчанию статус фильма "не любимый"
  bool status = false;

  // метод для изменения статуса фильма
  void toogleStatus() {
    status = !status;

    //если пользователь изменил на любимый, то добавляем в firebase
    if (status) {
      newFavorite();
    }
    //если пользователь удалил из любимых, то удаляем из firebase
    else {
      deletFavoriteNote();
    }
    notifyListeners();
  }

  // метод, который просматривает список любимых фильмов на firebse,
  // если такой есть, то возвращает true
  Future<bool> isfavorte() async {
    bool ret = false;
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/favoriteMovies/$_userUid.json',
    );
    try {
      final response = await http.get(url);
      final extradata = json.decode(response.body) as Map<String, dynamic>?;
      // если список пустой
      if (extradata?.isEmpty ?? true) {
        return false;
      }
      extradata!.forEach(
        (key, value) {
          // если в базе любимых фильмов есть фильм с таким id
          if (id == value['mediaId']) {
            ret = true;
          }
        },
      );
      print(ret);
      return ret;
    } catch (e) {
      print(e);
      return ret;
    }
  }

  // метод для добавления фильма в любимые фильмы
  Future<void> newFavorite() async {
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/favoriteMovies/$_userUid.json',
    );

    try {
      await http.post(
        url,
        body: json.encode({
          'mediaId': id,
          'imageUrl': imageUrl,
          'title': title,
          'originalTitle': originalTitle,
          'overview': overview,
          'date': date,
          'voteCount': voteCount,
          'type': getStringType(type),
        }),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
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

// метод для удаления записи из любимых
  Future<void> deletFavoriteNote() async {
    // получаем id записи в firebase
    String id = '';
    await searchIndexNote().then((value) {
      id = value;
    });

    //переходим к этой записи
    final getUrl = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/favoriteMovies/$_userUid/$id.json',
    );

    // и удаляем ее
    try {
      http.delete(getUrl);
    } catch (error) {
      throw error;
    }
  }

  // метод для получения индекса записи
  Future<String> searchIndexNote() async {
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/favoriteMovies/$_userUid.json',
    );
    String keyMedia = '';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((key, value) {
        if (id == value['mediaId']) {
          keyMedia = key.toString();
        }
      });
      print(keyMedia);
      return keyMedia;
    } catch (error) {
      throw error;
    }
  }
}

enum MediaType {
  movie,
  tvShow,
}
