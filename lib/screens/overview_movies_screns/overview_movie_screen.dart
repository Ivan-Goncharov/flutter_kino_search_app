// ignore_for_file: prefer_final_fields

import 'package:flutter_my_kino_app/models/popular_movies.dart';
import 'package:flutter_my_kino_app/models/popular_tv_shows.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/screens/overview_movies_screns/tv_shows_overview.dart';
import 'package:flutter_my_kino_app/widgets/error_message_widg.dart';
import 'package:flutter_my_kino_app/widgets/progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';

import '../../screens/overview_movies_screns/movies_overview.dart';

class OverviewMovieScreen extends StatefulWidget {
  static const routName = '.movieInfo';
  const OverviewMovieScreen({Key? key}) : super(key: key);
  @override
  State<OverviewMovieScreen> createState() => _OverviewMovieScreenState();
}

// экран для вывода обзорной информации по популярным фильмам и сериалам
class _OverviewMovieScreenState extends State<OverviewMovieScreen> {
  // флаг для переключения между страницами Сериалов/фильмов
  bool _isMovieScreen = true;
  bool _isError = false;
  bool _isLoading = false;

  PopularMovies _popularMovies = PopularMovies();
  PopularTvShowsModel _popularTvShows = PopularTvShowsModel();

  @override
  void initState() {
    _iniz();
    super.initState();
  }

  _iniz() async {
    setState(() {
      _isError = false;
      _isLoading = true;
    });

    await Future.wait([
      _popularMovies.requestMovies(),
      _popularTvShows.requestTVShows(),
    ]).then((value) {
      if (!value[0] || !value[1]) setState(() => _isError = true);
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  // кастомный стиль для названий страниц
  TextStyle _textStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  //счетчик для переключения страниц
  void _setCount(bool isMovie) {
    if (isMovie) {
      _count = 0;
    } else {
      _count = 1;
    }
  }

  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        body: _isError
            ? ErrorMessageWidget(
                handler: _iniz,
                size: size,
              )
            : SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //создаем переключатель между страницами
                      createToogleSwitch(colors, size),
                      _isLoading
                          ? animated()
                          : _isMovieScreen
                              ? MoviesOverView(popMovies: _popularMovies)
                              : TvShowsOverview(popTvShows: _popularTvShows),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget animated() {
    return Center(
      child: Lottie.network(
          'https://assets1.lottiefiles.com/datafiles/ZHlTlyhzTLf9ImW/data.json'),
    );
  }

  //toglle switch для переключения страниц
  ToggleSwitch createToogleSwitch(ColorScheme colors, Size size) {
    return ToggleSwitch(
      minWidth: size.width * 0.4,
      initialLabelIndex: _count,
      cornerRadius: 8.0,
      animate: true,
      animationDuration: 100,
      activeBgColor: [
        colors.surface,
        colors.surface,
      ],
      borderColor: [colors.surfaceVariant],
      borderWidth: 2,
      inactiveBgColor: colors.surfaceVariant,
      customTextStyles: [
        _textStyle(colors.onSurfaceVariant),
        _textStyle(colors.onSurfaceVariant)
      ],
      totalSwitches: 2,
      labels: const [
        'Фильмы',
        'Сериалы',
      ],
      onToggle: (index) {
        if (index == 0) {
          setState(() {
            _isMovieScreen = true;
            _setCount(true);
          });
        } else {
          setState(() {
            _isMovieScreen = false;
            _setCount(false);
          });
        }
      },
    );
  }
}
