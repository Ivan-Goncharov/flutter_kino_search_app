import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/error_message_widg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/movie.dart';
import '../providers/movies.dart';
import '../widgets/movie_item.dart';

//Экран для отображение всех результатов поиска
class AllSearchResult extends StatefulWidget {
  static const routNamed = './allSearch';
  const AllSearchResult({Key? key}) : super(key: key);

  @override
  _AllSearchResultState createState() => _AllSearchResultState();
}

class _AllSearchResultState extends State<AllSearchResult> {
  //переменные для работы с данными фильмов
  List<MediaBasicInfo> _movies = [];
  String _searchText = '';
  late Movies _provider;
  var _isLoading = false;
  var _isConnectError = false;
  var _isMovie = true;

  //при загрузке экрана выполняем инициализацию данных
  @override
  void didChangeDependencies() {
    //получаем аргументы(текст поиска) из Navigator
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _searchText = arg['searchText'] as String;
    _isMovie = arg['isMovie'] as bool;
    // и подключаем провайдер Movies
    _provider = Provider.of<Movies>(context, listen: false);
    _iniz();
    super.didChangeDependencies();
  }

  Future<void> _iniz() async {
    // ищем все фильмы по строке, введенной пользователем
    // сортируем результаты по убыванию кол-ва оценок
    setState(() {
      _isConnectError = false;
      _isLoading = true;
    });
    try {
      if (_isMovie) {
        await _provider.searchAllMovie(_searchText).then((_) => {
              _movies = _provider.itemsMovies,
              _movies
                  .sort((a, b) => b.voteCount!.compareTo(a.voteCount as int)),
              if (mounted) {setState(() => _isLoading = false)}
            });
      } else {
        await _provider.searchAllTVShow(name: _searchText).then((_) => {
              _movies = _provider.itemsMovies,
              _movies
                  .sort((a, b) => b.voteCount!.compareTo(a.voteCount as int)),
              if (mounted) {setState(() => _isLoading = false)}
            });
      }
    } catch (er) {
      setState(() {
        _isConnectError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Поиск: $_searchText'),
      ),
      //показываем экран загрузки, пока прогружаются все результаты поиска
      body: _isConnectError
          ? ErrorMessageWidget(handler: _iniz, size: size)
          : _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation_lottie/search_movie.json',
                        height: size.height * 0.6,
                        width: size.width * 0.6,
                      ),
                    ],
                  ),
                )

              // результаты поиска выводим в виде плиток,
              // которые использовали в экране поиска
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      return MovieItem(movie: _movies[index]);
                    },
                  ),
                ),
    );
  }
}
