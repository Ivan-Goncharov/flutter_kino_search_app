import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:flutter_my_kino_app/screens/all_search_results.dart';
import 'package:flutter_my_kino_app/widgets/error_message_widg.dart';
import 'package:flutter_my_kino_app/widgets/search_item.dart';
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
  // контроллер для перемещания по ListView и для отслеживания положения
  late ScrollController _scrollController;

  var _showCirculCenter = false;
  var _showCirculTexField = false;
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
    } else {}
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
                //поле для ввода названия фильма
                Container(
                  height: size.height * 0.1,
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
                      hintText: 'Введите название фильма',
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
                              handler: _errorUpdateScreen, size: size)
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
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //выводим заголовок поиска Фильмов
                                    _myTextController.text.isNotEmpty
                                        ? createTitleSearch(' Фильмы')
                                        : const SizedBox(),
                                    // если поиск не удался: выводим сообщение об ошибке
                                    // иначе выводим скроллинг лист с фильмами
                                    _movieProvider.itemsMovies.isEmpty &&
                                            _myTextController.text.isNotEmpty
                                        ? createFalseFound()
                                        : createSearchListView(
                                            size, _movieProvider.itemsMovies),

                                    //выводим сериалы
                                    //заголовок
                                    //выводим заголовок поиска Фильмов
                                    _myTextController.text.isNotEmpty
                                        ? createTitleSearch(' Сериалы')
                                        : const SizedBox(),
                                    // если поиск не удался: выводим сообщение об ошибке
                                    // иначе выводим скроллинг лист с фильмами
                                    _movieProvider.itemsTVshows.isEmpty &&
                                            _myTextController.text.isNotEmpty
                                        ? createFalseFound()
                                        : createSearchListView(
                                            size, _movieProvider.itemsTVshows),
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

  // данный метод создает список фильмов/сериалов на основе поиска
  Container createSearchListView(Size size, List<Movie> list) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: list.length,
        itemBuilder: (context, index) {
          //если конец списка, то выводим кнопку,
          //которая предлагает перейти на экран со всеми результатами
          if (index == list.length - 1 && list.length > 9) {
            return getEndButton(size);
          }
          return SearchItem(movie: list[index]);
        },
      ),
    );
  }

  //кнопка перехода на экран со всеми результатми
  Widget getEndButton(Size size) {
    // const Color.fromRGBO(20, 20, 20, 1)
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      height: size.height * 0.15,
      width: size.width * 0.35,
      child: TextButton(
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all<Color>(
        //       Theme.of(context).colorScheme.surface),
        // ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AllSearchResult.routNamed,
            arguments: _myTextController.text,
          );
        },
        child: Text(
          'Все результаты',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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

  // заголовок поиска
  Text createTitleSearch(String titelSearch) {
    final title = titelSearch;
    return Text(
      title,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
