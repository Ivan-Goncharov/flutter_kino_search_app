import 'package:flutter/material.dart';

import '../../models/movies_history.dart';
import '../../widgets/listview_of_genres.dart';
import '../../models/popular_movies.dart';
import '../../widgets/error_message_widg.dart';
import '../../widgets/horizont_movie_scroll.dart';

// Обзорный экран популярных фильмов
class MoviesOverView extends StatefulWidget {
  const MoviesOverView({Key? key}) : super(key: key);

  @override
  State<MoviesOverView> createState() => _MoviesOverViewState();
}

class _MoviesOverViewState extends State<MoviesOverView> {
  //получаем экземпляр класса для запросов api по популярным фильмам
  final PopularMovies _popMovies = PopularMovies();
  var _isLoading = true;
  var _isError = false;
  @override
  void initState() {
    _iniz();
    super.initState();
  }

//делаем запрос, обрабатывая состояние запроса
  _iniz() {
    setState(() {
      _isError = false;
    });
    try {
      _popMovies.requestMovies().then((value) {
        if (value) {
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            _isError = true;
          });
          return;
        }
      });
    } catch (error) {
      print('ошибка в _iniz/movie_overview $error');
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //если ошибка, то выводим экран для ошибки
    return _isError
        ? ErrorMessageWidget(handler: _iniz, size: size)
        : _isLoading
            //загрузочный экран
            ? getProgressBar()
            : Container(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    //список популярных фильмов
                    HorrizontalMovieScroll(
                      title: ' Популярные фильмы',
                      list: _popMovies.popularMovies,
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
                      list: _popMovies.topRatedMovies,
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
                      list: _popMovies.nowPlayMovies,
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
                      list: _popMovies.upcommingMovies,
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

//прогресс индикатор
  Container getProgressBar() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 270),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
