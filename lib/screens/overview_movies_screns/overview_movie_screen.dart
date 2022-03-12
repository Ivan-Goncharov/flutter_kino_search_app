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
  bool _isMovie = true;

  // кастомный стиль для названий страниц
  TextStyle _textStyle(Color color) {
    return TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //создаем переключатель между страницами
                createToogleSwitch(colors, size),
                _isMovie ? const MoviesOverView() : const Text('Сериалы'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //toglle switch для переключения страниц
  ToggleSwitch createToogleSwitch(ColorScheme colors, Size size) {
    return ToggleSwitch(
      minWidth: size.width * 0.4,
      initialLabelIndex: 0,
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
            _isMovie = true;
          });
        } else {
          setState(() {
            _isMovie = false;
          });
        }
      },
    );
  }
}
