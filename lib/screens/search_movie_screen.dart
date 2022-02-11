import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:flutter_my_kino_app/widgets/movie_item.dart';
import 'package:provider/provider.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  //контроллер для прослушивания изменений в текстовом поле
  final _myTextController = TextEditingController();

  //провайдер получим позже, когда будет доступен context
  late Movies _movieProvider;
  //список с фильмами из поиска
  List<Movie> movie = [];
  // контролле для перемещания по ListView и для отслеживания положения
  late ScrollController _scrollController;
  //страница поиска фильмов по умолчанию
  var page = 1;
  var _isLoading = false;

  //инициализируем контроллеры с функцией
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _myTextController.addListener(_inputTextChange);
    super.initState();
  }

  //позволяет отследить положение прокручеваемого списка
  // при достижении конца списка - список обновляется
  _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('конец списка');
      setState(() {
        _isLoading = true;
        page += 1;
      });
      _pageChange();
      _isLoading = false;
    }
  }

  // метод для поиска следующих результатов после изменения страницы
  Future<void> _pageChange() async {
    try {
      //вызываем метод поиска с текстом от пользователя
      await _movieProvider.searchMovie(
          name: _myTextController.text, page: page);
      print(page);
    } catch (er) {
      print('Найдена ошибка $er');
    } finally {
      changeText();
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  // метод вызывается при изменении текста в поле ввода
  //меняем страницу поиска на 1, чтобы обнулить результат предыдщего поиска
  Future<void> _inputTextChange() async {
    try {
      page = 1;
      //вызываем метод поиска с текстом от пользователя
      await _movieProvider.searchMovie(
          name: _myTextController.text, page: page);

      print(page);
    } catch (er) {
      print('Найдена ошибка $er');
    } finally {
      changeText();
    }
  }

  //метод для изменения списка с информацией о найденных фильмах
  void changeText() {
    setState(() {
      movie = _movieProvider.items;
    });
  }

  //переопределяем метод для вызова провайдера поиска фильмов
  @override
  void didChangeDependencies() {
    _movieProvider = Provider.of<Movies>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск фильмов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Ищем фильмы'),
                  ],
                ),
              )
            : Column(
                children: [
                  //поле для ввода названия фильма
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Введите название фильма',
                    ),
                    controller: _myTextController,
                  ),

                  //выводим снизу от поиска ListView с кастомными карточками найденных фильмов
                  movie.isEmpty && _myTextController.text.isNotEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Ничего не найдено'),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: movie.length,
                            itemBuilder: (context, index) {
                              return MovieItem(movie: movie[index]);
                            },
                            controller: _scrollController,
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
