// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/movie.dart';

// класс для получения информации об избранных фильмах
class FavoriteMovie with ChangeNotifier {
  final _userUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  // получаем любимые фильмы с firebase
  Future<List<MediaBasicInfo>?> getAndFetchFavoriteNote() async {
    if (_userUid.isEmpty) {
      return [];
    }
    final url = Uri.https(
      'search-movie-app-809ca-default-rtdb.firebaseio.com',
      '/favoriteMovies/$_userUid.json',
    );
    try {
      final response = await http.get(url);

      final extradata = json.decode(response.body) as Map<String, dynamic>?;

      if (extradata?.isEmpty ?? true) {
        return [];
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
      return loadedMedia;
    } catch (error) {
      print('ошибка в getand fetch');
      return null;
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
