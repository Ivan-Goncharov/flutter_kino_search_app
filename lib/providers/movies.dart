import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_my_kino_app/models/movie_info.dart';
import 'package:http/http.dart' as http;

import 'movie.dart';
import '../models/search_movie_model.dart';

//класс провайдер для создания списка фильмов в поиске
class Movies with ChangeNotifier {
  //список фильмов
  List<Movie> _items = [];

  List<Movie> get items {
    return [..._items];
  }

  //метод для поиска фильмов
  Future searchMovie({required String name, required int page}) async {
    _items = [];
    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru&query=${Uri.encodeFull(name)}&page=$page&include_adult=false');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        //получаем результаты поиска и проходимся по списку, создавая фильмы
        final movieSearch = SearchMovie.fromJson(json.decode(response.body));

        for (int i = 0; i < movieSearch.results.length; i++) {
          final movieItem = movieSearch.results[i];
          _items.add(
            Movie(
              id: movieItem.id,
              // imageUrl: movieItem.posterPath,
              imageUrl: movieItem.posterPath == null
                  ? "assets/image/noImageFound.png"
                  : "${movieItem.posterPath}",
              title: movieItem.title,
              originalTitle: movieItem.originalTitle,
              overview: movieItem.overview,
              date: movieItem.releaseDate!.substring(0, 4),
            ),
          );
        }
        return _items;
      } //если результатов нет, то выкидываем ошибку
      catch (error) {
        print('$error');
      }
    }
    notifyListeners();
  }
}
