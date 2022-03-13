// ignore_for_file: avoidwidget.print

import 'package:flutter/material.dart';

import '../../models/movies_history.dart';
import '../../widgets/listview_of_genres.dart';
import '../../models/popular_movies.dart';
import '../../widgets/horizont_movie_scroll.dart';

// Обзорный экран популярных фильмов
class MoviesOverView extends StatelessWidget {
  final PopularMovies popMovies;
  const MoviesOverView({Key? key, required this.popMovies}) : super(key: key);

  //получаем экземпляр класса для запросов api по популярным фильмам
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //если ошибка, то выводим экран для ошибки
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          //список популярных фильмов
          HorrizontalMovieScroll(
            title: ' Популярные фильмы',
            list: popMovies.popularMovies,
            size: size,
            isMovie: true,
            isSearch: false,
            historySearch: MovieHistory(''),
            textController: '',
            typeScroll: 'популярные фильмы',
          ),
          const SizedBox(
            height: 10,
          ),

          //список лучших фильмов
          HorrizontalMovieScroll(
            title: ' Лучшие фильмы',
            list: popMovies.topRatedMovies,
            size: size,
            isMovie: true,
            isSearch: false,
            historySearch: MovieHistory(''),
            textController: '',
            typeScroll: 'лучшие фильмы',
          ),

          //список жанров
          ListViewOfGenres(),
          const SizedBox(
            height: 10,
          ),

          //список фильмов, которые сейчас показывают в кино
          HorrizontalMovieScroll(
            title: ' Сейчас смотрят в кино',
            list: popMovies.nowPlayMovies,
            size: size,
            isMovie: true,
            isSearch: false,
            historySearch: MovieHistory(''),
            textController: '',
            typeScroll: 'сейчас смотрят',
          ),

          const SizedBox(
            height: 10,
          ),

          //список фильмов, которые будут в кинотеатрах
          HorrizontalMovieScroll(
            title: ' Скоро в кинотеатрах',
            list: popMovies.upcommingMovies,
            size: size,
            isMovie: true,
            isSearch: false,
            historySearch: MovieHistory(''),
            textController: '',
            typeScroll: 'скоро в кино',
          ),
        ],
      ),
    );
  }
}
