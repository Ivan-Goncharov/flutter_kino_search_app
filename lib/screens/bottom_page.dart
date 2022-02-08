import 'package:flutter/material.dart';

import './about_it.dart';
import './overview_movie_screen.dart';
import './search_movie_screen.dart';

/// Экран для BottomNavigation
class BottomPage extends StatefulWidget {
  const BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  //список экранов для навигации
  final List<Widget> _pages = [
    OverviewMovieScreen(),
    SearchMovieScreen(),
    AboutIt(),
  ];

  //переменная для сохранения индекса выбранной страницы
  var _selectedPage = 1;

  //метод для изменения индекса
  void _changeIndex(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //наполнение меняем, взависимости от экрана
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        currentIndex: _selectedPage,
        onTap: _changeIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.home_outlined),
            label: 'Обзор',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.info_outline),
            label: 'О нас',
          )
        ],
      ),
    );
  }
}
