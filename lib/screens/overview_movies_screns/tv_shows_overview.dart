// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/models/movies_history.dart';
import 'package:flutter_my_kino_app/widgets/horizont_movie_scroll.dart';
import '../../models/popular_tv_shows.dart';

//экран для вывода поплуряных и рейтинговых сериалов
class TvShowsOverview extends StatelessWidget {
  final PopularTvShowsModel popTvShows;
  const TvShowsOverview({Key? key, required this.popTvShows}) : super(key: key);

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
              //популярные сериалы
              HorrizontalMovieScroll(
                title: 'Популярные сериалы',
                list: popTvShows.popularTvShows,
                size: size,
                isMovie: false,
                isSearch: false,
                historySearch: MovieHistory(''),
                textController: '',
                typeScroll: 'PopularTvShows',
              ),

              //рейтинговые сериалы
              //популярные сериалы
              HorrizontalMovieScroll(
                title: 'Лучшие сериалы',
                list: popTvShows.topRatedTvShow,
                size: size,
                isMovie: false,
                isSearch: false,
                historySearch: MovieHistory(''),
                textController: '',
                typeScroll: 'PopularTvShows',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
