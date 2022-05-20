import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/media_widgets/genre_grid_view.dart';
import 'package:lottie/lottie.dart';

import '../../models/media_models/lists_of_media.dart';
import '../../providers/movie.dart';
import '../../widgets/system_widgets/error_message_widg.dart';

//экран для вывода фильмов соотвествующего жанра
class GenresOfMovies extends StatefulWidget {
  static const routNamed = './genresOfMovies';

  const GenresOfMovies({
    Key? key,
  }) : super(key: key);

  @override
  State<GenresOfMovies> createState() => _GenresOfMoviesState();
}

class _GenresOfMoviesState extends State<GenresOfMovies> {
  //экземпляр класса для api запросов
  final ListsOfMedia _popMovies = ListsOfMedia();
  //список фильмов заполним позже
  List<MediaBasicInfo> _listMedia = [];

  //два флага для загрузки и для ошибки
  bool _isLoading = false;
  bool _isError = false;
  String _mediaType = '';

  //id и name жанра получим чуть позже
  int _genreId = 0;
  String _genreName = '';

  @override
  void didChangeDependencies() {
    //получаем id и name через аргументы навиагтора
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _genreId = arg['genreId'];
    _genreName = arg['genreName'];
    _mediaType = arg['mediaType'];

    //производим инициализацию списка фильмов
    _inizMovie();
    super.didChangeDependencies();
  }

  // метод для инициализации списка фильмов
  _inizMovie() async {
    setState(() {
      _isError = false;
      _isLoading = true;
    });
    // вызываем метод для api запроса, ждем результат и обрабатываем его
    await _popMovies
        .getListOfGenres(genre: _genreId, mediaType: _mediaType)
        .then((value) {
      if (!mounted) return;
      if (value != null) {
        _listMedia = value;
        setState(() => _isLoading = false);
      } else {
        setState(() => _isError = true);
      }
    });
  }

  // cтиль для заголовка appBar
  Text getTextTitle() {
    return Text(
      _genreName,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: getTextTitle(),
        ),
        body: _isError
            //выводим ошибку, если произошел сбой в поиске
            ? ErrorMessageWidget(handler: _inizMovie, size: size)
            : _isLoading

                //при загрузке выводим загрузочный спиннер
                ? Container(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/animation_lottie/movie_loading.json',
                      height: size.height * 0.4,
                      width: size.width * 0.4,
                    ),
                  )

                //прокручивающийся  список фильмао
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //проверяем наличие фильмов в списке
                          _listMedia.isNotEmpty

                              //если есть, то выводим GridView  с фильмами
                              ? ItemGenreGridView(
                                  listOfMedia: _listMedia,
                                )

                              // если список пустой, то выводим сообщение об этом
                              : const Text(
                                  'Поиск не удался',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
