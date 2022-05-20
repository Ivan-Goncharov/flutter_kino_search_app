import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import '../../screens/overview_movies_screns/movies_overview.dart';
import '../../screens/overview_movies_screns/tv_shows_overview.dart';
import '../../models/media_models/lists_of_media.dart';
import '../../widgets/system_widgets/error_message_widg.dart';
import '../../widgets/system_widgets/switch_pages.dart';

// экран для вывода обзорной информации по популярным фильмам и сериалам
class OverviewMovieScreen extends StatefulWidget {
  static const routName = '.movieInfo';
  const OverviewMovieScreen({Key? key}) : super(key: key);
  @override
  State<OverviewMovieScreen> createState() => _OverviewMovieScreenState();
}

class _OverviewMovieScreenState extends State<OverviewMovieScreen> {
  // флаг для переключения между страницами Сериалов/фильмов
  PageController _controller = PageController(
    initialPage: 0,
  );
  bool _isError = false;
  bool _isLoading = false;

  //создаем экземпляр модели, которая выполняет запросы по популярным фильмам
  ListsOfMedia _popularMedia = ListsOfMedia();

  @override
  void initState() {
    _iniz();
    _controller.addListener(_listenerPage);
    super.initState();
  }

  //метод для переключения toogleSwithc, если пользователь свайпнул страницу
  _listenerPage() {
    setState(() {
      _count = _controller.page?.toInt() ?? 0;
    });
  }

  //метод для инициализации данных
  _iniz() async {
    setState(() {
      _isError = false;
      _isLoading = true;
    });

    //выполняем запрос поиск популярных фильмов и сериалов
    await _popularMedia.requestMediaLists().then((value) {
      if (!value) setState(() => _isError = true);
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
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
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //создаем переключатель между страницами
                    PagesToogleSwitch(
                        count: _count,
                        changePageFirst: () {
                          setState(() {
                            _controller.animateToPage(0,
                                duration: const Duration(microseconds: 300),
                                curve: Curves.easeInBack);
                            _setCount(true);
                          });
                        },
                        changePageSecond: () {
                          setState(() {
                            _controller.animateToPage(1,
                                duration: const Duration(microseconds: 300),
                                curve: Curves.easeIn);
                            _setCount(false);
                          });
                        }),
                    _isLoading
                        ?
                        //виджет загрузки
                        AnimationLoadingWidget()
                        :
                        //все остальное место занимает PageView
                        Expanded(
                            child: PageView(
                              controller: _controller,
                              children: [
                                //страница с фильмами
                                MoviesOverView(popMovies: _popularMedia),

                                //страница с сериалами
                                TvShowsOverview(popTvShows: _popularMedia),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}

//анимированный виджет загрузки
class AnimationLoadingWidget extends StatelessWidget {
  const AnimationLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 150),
      alignment: Alignment.center,
      child: Lottie.asset(
        'assets/animation_lottie/movie_loading.json',
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
      ),
    );
  }
}
