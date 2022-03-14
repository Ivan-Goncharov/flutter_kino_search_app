import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import '../models/movies_history.dart';
import '../widgets/error_message_widg.dart';
import '../widgets/horizont_movie_scroll.dart';

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
  //класс для сохранения истории поиска
  late MovieHistory _historySearch;
  // контроллер для перемещания по ListView и для отслеживания положения
  late ScrollController _scrollController;

  var _showCirculCenter = false;
  var _showCirculTexField = false;
  var _isConnectError = false;
  var _isLoading = true;
  var text = '';

  //инициализируем контроллеры с функцией
  @override
  void initState() {
    _scrollController = ScrollController();
    _myTextController.addListener(_inputTextChange);

    // получаем экземпляр истории поиска и вызываем метод - запрос на получение истории в firebase
    _historySearch = MovieHistory(FirebaseAuth.instance.currentUser!.uid);
    //делаем запрос и перестраиваем экран после завершения метода
    _historySearch.getAndFetchNote().then(
          (_) => setState(() => _isLoading = false),
        );

    super.initState();
  }

  // метод вызывается при изменении текста в поле ввода
  _inputTextChange() async {
    final _isEmpty = _movieProvider.itemsMovies.isEmpty;
    //производим поиск, если поле ввода не пустое
    // и не совпадает с вводом, которое было до этого
    //это обход, т.к. при  скрытии клавиатуры TextField (при скроллинге)
    // вызывается слушатель и перестраивает ListView
    if (_myTextController.text.isNotEmpty && _myTextController.text != text) {
      text = _myTextController.text;
      if (_isEmpty) {
        setState(() {
          _showCirculCenter = true;
          _isConnectError = false;
        });
      } else {
        setState(() {
          _showCirculTexField = true;
        });
      }
      try {
        //вызываем метод поиска фильмов с текстом от пользователя
        await _movieProvider.searchMovie(name: _myTextController.text);
        await _movieProvider.searchTVShow(name: _myTextController.text);
        if (_isEmpty) {
          setState(() {
            _showCirculCenter = false;
          });
        } else {
          setState(() {
            _showCirculTexField = false;
          });
        }
      } catch (er) {
        // вызываем экран с ошибкой
        // прекращаем анимацию загрузки
        setState(() {
          _isConnectError = true;
          _showCirculTexField = false;
        });
        print('возникла ошибка в search_movie/iniz: $er');
      }
    } // если клаиватура скрыта, то просто выводим предыдущие результаты
    else if (_myTextController.text.isNotEmpty) {
      return;
    } else {
      _movieProvider.setItemsMovie();
      _movieProvider.setItemsTVshows();
    }
  }

  //метод для повторной попытки поиска,
  //если произошла ошибка и пользователь захотел попробовать обновить результаты
  _errorUpdateScreen() async {
    if (_myTextController.text.isNotEmpty) {
      setState(() {
        _showCirculCenter = true;
        _isConnectError = false;
      });
      try {
        //вызываем метод поиска фильмов с текстом от пользователя
        await _movieProvider.searchMovie(name: _myTextController.text);
        await _movieProvider.searchTVShow(name: _myTextController.text).then(
          (_) {
            setState(() {
              _showCirculCenter = false;
            });
          },
        );
      } catch (er) {
        //вызываем экран с ошибкой
        setState(() {
          _isConnectError = true;
        });
      }
    }
  }

  //переопределяем метод для вызова провайдера поиска фильмов
  @override
  void didChangeDependencies() {
    _movieProvider = Provider.of<Movies>(context, listen: true);

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
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_outlined),
                      // Если в полу ввода изменился текст, а в списках
                      // фильмов и сериалов еще есть фильмы, то мы индикатор
                      // загрузки показываем в поле ввода
                      suffixIcon: _showCirculTexField
                          ? Container(
                              margin: const EdgeInsets.all(7),
                              child: const CircularProgressIndicator(),
                            )
                          //если поле ввода не пустое, то выводим иконку,
                          // которая позволяет стереть поле ввода
                          : _myTextController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _myTextController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                  ),
                                )
                              : const SizedBox(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      hintText: 'Поиск',
                    ),
                    controller: _myTextController,
                  ),
                ),

                // если будет ошибка, то показываем виджет с описанием
                // и кнопкой для обновления
                Expanded(
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      _isConnectError
                          ? ErrorMessageWidget(
                              handler: _errorUpdateScreen,
                              size: size,
                            )
                          :
                          // в зависимости от значения загрузки: выводим виджеты
                          _showCirculCenter && _myTextController.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Идет поиск фильмов',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              :
                              //выводим снизу от поиска ListView с кастомными карточками найденных фильмов
                              // если текст не введен, то выводим прошлый поиск
                              _myTextController.text.isEmpty
                                  ? _historySearch.historySearch.isEmpty &&
                                          _isLoading
                                      ? const SizedBox()
                                      : HorrizontalMovieScroll(
                                          title: ' Ранее вы искали',
                                          list: _historySearch.historySearch,
                                          size: size,
                                          isMovie: false,
                                          isSearch: false,
                                          historySearch: _historySearch,
                                          textController:
                                              _myTextController.text,
                                          typeScroll: 'ранее вы искали',
                                        )
                                  :
                                  // если не найдено ни сериалов, ни фильмов, выводим сообщение об ошибке поиска
                                  _movieProvider.itemsMovies.isEmpty &&
                                          _movieProvider.itemsTVshows.isEmpty
                                      ? createFalseFound()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // выводим фильмы, если список пуст, то ничего не выводим
                                            _movieProvider.itemsMovies.isEmpty
                                                ? const SizedBox()
                                                : HorrizontalMovieScroll(
                                                    title: ' Фильмы',
                                                    list: _movieProvider
                                                        .itemsMovies,
                                                    size: size,
                                                    isMovie: true,
                                                    isSearch: true,
                                                    historySearch:
                                                        _historySearch,
                                                    textController:
                                                        _myTextController.text,
                                                    typeScroll: 'поиск фильмов',
                                                  ),

                                            //выводим сериалы
                                            // если список пуст, то ничего не выводим
                                            _movieProvider.itemsTVshows.isEmpty
                                                ? const SizedBox()
                                                : HorrizontalMovieScroll(
                                                    title: ' Cериалы',
                                                    list: _movieProvider
                                                        .itemsTVshows,
                                                    size: size,
                                                    isMovie: false,
                                                    isSearch: true,
                                                    historySearch:
                                                        _historySearch,
                                                    textController:
                                                        _myTextController.text,
                                                    typeScroll:
                                                        'поиск сериалов',
                                                  ),
                                          ],
                                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// создает виджет с ошибкой поиска
  Center createFalseFound() {
    return const Center(
      heightFactor: 8,
      child: Text(
        'Ничего не нашлось',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
