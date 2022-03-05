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
    const SearchMovieScreen(),
    const AboutIt(),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconSize: 30,
        currentIndex: _selectedPage,
        showUnselectedLabels: false,
        onTap: _changeIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Обзор',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'О нас',
          )
        ],
      ),
    );
  }
}
