import 'package:flutter/material.dart';

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
}

enum MediaType {
  movie,
  tvShow,
}
