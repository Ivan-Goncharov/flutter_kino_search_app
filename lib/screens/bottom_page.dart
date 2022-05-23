import 'package:flutter/material.dart';

import 'overview_movies_screns/overview_movie_screen.dart';
import './about_it.dart';
import './search_movie_screen.dart';
import '../screens/favorites_movies_screen.dart';
import '../screens/overview_movies_screns/overview_movie_screen.dart';

/// Экран для BottomNavigation
class BottomPage extends StatefulWidget {
  const BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  //список экранов для навигации
  final List<Widget> _pages = [
    const OverviewMovieScreen(),
    const FavoritesMoviesScreen(),
    const SearchMovieScreen(),
    const AboutIt(),
  ];

  //переменная для сохранения индекса выбранной страницы
  var _selectedPage = 0;

  //метод для изменения индекса
  void _changeIndex(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorSc = Theme.of(context).colorScheme;
    return Scaffold(
      //наполнение меняем, взависимости от экрана
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        iconSize: 30,
        currentIndex: _selectedPage,
        selectedItemColor: colorSc.secondary,
        unselectedItemColor: colorSc.primary,
        showUnselectedLabels: false,
        onTap: _changeIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'Обзор',
            backgroundColor: colorSc.surfaceVariant,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.star_border),
            label: 'Избранные',
            backgroundColor: colorSc.surfaceVariant,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Поиск',
            backgroundColor: colorSc.surfaceVariant,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.info_outline),
            label: 'О сервисе',
            backgroundColor: colorSc.surfaceVariant,
          ),
        ],
      ),
    );
  }
}
