import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/screens/introduction_screens/pages_intro.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final PageController _controller = PageController(
    initialPage: 0,
  );
  int _currentPage = 0;
  Timer? _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      }
      _controller.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              PagesIntro1(
                lottieAnimation: Lottie.asset(
                  'assets/animation_lottie/search_movie.json',
                ),
                title: 'Поиск фильмов',
                subtitle: 'Ищите ваши любимые фильмы и сериалы.',
              ),
              PagesIntro1(
                lottieAnimation: Lottie.asset(
                  'assets/animation_lottie/monitoring.json',
                ),
                title: 'Мониторинг новинок',
                subtitle: 'Следите за новинками и популярными работами.',
              ),
              PagesIntro1(
                lottieAnimation: Lottie.asset(
                    'assets/animation_lottie/watch_providers.json',
                    height: size.height * 0.5,
                    width: size.width * 0.5),
                title: 'Просмотр фильмов и сериалов',
                subtitle:
                    'Выбирайте фильм и смотрите его в удобном для вас сервисе.',
              ),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.9),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
            ),
          ),
        ],
      ),
    );
  }
}
