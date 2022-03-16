import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../providers/movie.dart';
import '../../widgets/error_message_widg.dart';
import '../../models/lists_of_media.dart';
import '../../widgets/detailed_widget/get_image.dart';
import '../movie_detailes_info/detailed_movie_info.dart';

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
                ? getProgressBar(size)
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // если список пустой, то выводим сообщеие об этом
                          //если нет, то выводим GridView  с фильмами
                          _listMedia.isNotEmpty
                              ? createGridView()
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

// метод, который возвращаем GridView c фильмами конкретного жанра
  Widget createGridView() {
    return SizedBox(
      width: double.infinity,
      //заполняем экран сеткой в 3 элемента
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          //тэг hero для анимации
          final heroTag = 'genreGridView$index${_listMedia[index].id}';
          return GestureDetector(
            onTap: () {
              //обрабатываем нажатие на постер
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    // вызываем деатльную информацию о фильме
                    // передаем фильм и тэг hero
                    return DetailedInfoScreen(
                      movie: _listMedia[index],
                      heroTag: heroTag,
                    );
                  }),
                  transitionDuration: const Duration(milliseconds: 700),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            // выводим постер фильма через анимацию
            child: Hero(
              tag: heroTag,
              child: GetImage(
                  imageUrl: _listMedia[index].imageUrl,
                  title: _listMedia[index].title,
                  height: 300,
                  width: 150),
            ),
          );
        },
        itemCount: _listMedia.length,
      ),
    );
  }

//загрузочный спиннер
  Container getProgressBar(Size size) {
    return Container(
      alignment: Alignment.center,
      child: Lottie.asset(
        'assets/animation_lottie/movie_loading.json',
        height: size.height * 0.4,
        width: size.width * 0.4,
      ),
    );
  }
}
