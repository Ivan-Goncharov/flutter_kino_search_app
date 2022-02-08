import 'package:flutter/material.dart';

//класс - провайдер для создания одного фильма
class Movie with ChangeNotifier {
  int? id;
  // String? imdbId;
  String? imageUrl;
  String? title;
  String? originalTitle;
  String? overview;
  String? date;

  Movie({
    required this.id,
    // required this.im
    required this.imageUrl,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.date,
  });
}
