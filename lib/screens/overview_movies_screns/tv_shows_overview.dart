import 'package:flutter/material.dart';

import '../../models/firebase_models/movies_history.dart';
import '../../models/media_models/lists_of_media.dart';
import '../../widgets/media_widgets/horizont_movie_scroll.dart';
import '../../widgets/media_widgets/listview_of_genres.dart';

//экран для вывода поплуряных и рейтинговых сериалов
class TvShowsOverview extends StatelessWidget {
  // final PopularTvShowsModel popTvShows;
  final ListsOfMedia popTvShows;
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
                text: '',
                typeScroll: 'PopularTvShows',
              ),

              ListViewOfGenres(isMovie: false),
              SizedBox(
                height: 10,
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
                text: '',
                typeScroll: 'PopularTvShows',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
