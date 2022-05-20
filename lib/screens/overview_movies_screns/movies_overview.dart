import 'package:flutter/material.dart';

import '../../models/firebase_models/movies_history.dart';
import '../../models/media_models/lists_of_media.dart';
import '../../widgets/media_widgets/horizont_movie_scroll.dart';
import '../../widgets/media_widgets/listview_of_genres.dart';

// Обзорный экран популярных фильмов
class MoviesOverView extends StatelessWidget {
  final ListsOfMedia popMovies;
  const MoviesOverView({Key? key, required this.popMovies}) : super(key: key);

  //получаем экземпляр класса для запросов api по популярным фильмам
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //если ошибка, то выводим экран для ошибки
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Container(
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
                text: '',
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
                text: '',
                typeScroll: 'лучшие фильмы',
              ),

              //список жанров
              ListViewOfGenres(
                isMovie: true,
              ),
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
                text: '',
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
                text: '',
                typeScroll: 'скоро в кино',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
