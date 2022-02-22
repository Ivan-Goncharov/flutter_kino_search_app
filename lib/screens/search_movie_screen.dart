import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:flutter_my_kino_app/screens/all_search_results.dart';
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
  // контроллер для перемещания по ListView и для отслеживания положения
  late ScrollController _scrollController;
  //страница поиска фильмов по умолчанию
  var page = 1;
  var _isLoading = false;
  var _isConnectError = false;
  var text = '';
  //инициализируем контроллеры с функцией

  @override
  void initState() {
    _scrollController = ScrollController();
    _myTextController.addListener(_inputTextChange);
    super.initState();
  }

  // метод вызывается при изменении текста в поле ввода
  Future<void> _inputTextChange() async {
    //производим поиск, если поле ввода не пустое
    // и не совпадает с вводом, которое было до этого
    //это обход, т.к. при  скрытии клавиатуры TextField (при скроллинге)
    // вызывается слушатель и перестраивает ListView
    if (_myTextController.text.isNotEmpty && _myTextController.text != text) {
      text = _myTextController.text;
      setState(() {
        _isLoading = true;
        _isConnectError = false;
      });
      try {
        page = 1;
        //вызываем метод поиска с текстом от пользователя
        await _movieProvider
            .searchMovie(name: _myTextController.text, page: page)
            .then((_) => {
                  setState(() {
                    _isLoading = false;
                  }),
                });
        changeText();
      } catch (er) {
        //вызываем экран с ошибкой
        setState(() {
          _isConnectError = true;
        });
      }
    }
    // если клаиватура скрыта, то просто выводим предыдущие результаты
    else if (_myTextController.text.isNotEmpty) {
      setState(() {
        movie = _movieProvider.items;
        movie.sort(
          (a, b) => b.voteCount!.compareTo(a.voteCount as int),
        );
      });
    } else {
      //если в поле ввода пусто, то выводим на экран последние 10 фильмов,
      //которые открывал пользователь
      setState(() {
        movie = _movieProvider.historySearch;
      });
    }
  }

  //метод для изменения списка с информацией о найденных фильмах
  void changeText() {
    setState(() {
      movie = _movieProvider.items;
      //сортируем фильмы по популярности
      movie.sort(
        (a, b) => b.voteCount!.compareTo(a.voteCount as int),
      );
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

  //кнопка перехода на экран со всеми результатми
  Widget getEndButton(Size size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: size.height * 0.06,
        width: size.width * 0.9,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromRGBO(20, 20, 20, 1)),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              AllSearchResult.routNamed,
              arguments: _myTextController.text,
            );
          },
          child: const Text(
            'Все результаты',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск фильмов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //поле для ввода названия фильма
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Введите название фильма',
                ),
                controller: _myTextController,
              ),
            ),
            // если будет ошибка, то показываем виджет с описанием
            // и кнопкой для обновления
            _isConnectError
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'У нас что-то сломалось',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Му уже решаем проблему. Возможно, проблемы с интернет соединением. Попробуйте еще раз обновить',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: size.height * 0.05,
                            width: size.width * 0.6,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(20, 20, 20, 1)),
                              ),
                              onPressed: () {
                                _inputTextChange();
                              },
                              child: const Text('Обновить'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                :
                // в зависимости от значения загрузки: выводим виджеты
                _isLoading && _myTextController.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Идет поиск фильмов'),
                          ],
                        ),
                      )
                    :
                    //выводим снизу от поиска ListView с кастомными карточками найденных фильмов
                    movie.isEmpty && _myTextController.text.isNotEmpty
                        ? const Center(
                            // padding: EdgeInsets.only(top: 10),
                            heightFactor: 8,
                            child: Text(
                              'Ничего не нашлось',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemCount: movie.length,
                              itemBuilder: (context, index) {
                                //если конец списка, то выводим кнопку,
                                //которая предлагает перейти на экран со всеми результатами
                                if (index == movie.length - 1 &&
                                    movie.length > 1 &&
                                    movie.length > 9) {
                                  return getEndButton(size);
                                }

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
