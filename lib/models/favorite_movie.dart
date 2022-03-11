import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:http/http.dart' as http;

class FavoriteMovie with ChangeNotifier {
  final _userUid = FirebaseAuth.instance.currentUser!.uid;

  // получаем любимые фильмы с firebase
  Future<List<MediaBasicInfo>> getAndFetchFavoriteNote() async {
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
      rethrow;
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
