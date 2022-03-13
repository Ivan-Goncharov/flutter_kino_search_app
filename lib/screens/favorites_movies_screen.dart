import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/error_message_widg.dart';

import '../models/favorite_movie.dart';
import '../providers/movie.dart';
import '../widgets/detailed_widget/get_image.dart';
import '../screens/movie_detailes_info/detailed_movie_info.dart';

// Экран для вывода избранных фильмов и сериалов
class FavoritesMoviesScreen extends StatefulWidget {
  const FavoritesMoviesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesMoviesScreen> createState() => _FavoritesMoviesScreenState();
}

class _FavoritesMoviesScreenState extends State<FavoritesMoviesScreen> {
  FavoriteMovie? _favoriteMovie;
  bool _isLoading = false;
  bool _isError = false;

  //список заполним позже
  List<MediaBasicInfo> _listMedia = [];

  @override
  void initState() {
    _favoriteMovie = FavoriteMovie();
    try {
      getFavorite();
    } catch (er) {
      print('init state ошибка');
    }
    super.initState();
  }

// метод для получения данных об избранных фильмах в firebase
  void getFavorite() {
    _listMedia = [];
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    _favoriteMovie!.getAndFetchFavoriteNote().then((value) {
      if (value != null) {
        setState(() {
          _listMedia = value;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: _isError
            ? ErrorMessageWidget(handler: getFavorite, size: size)
            : _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Избранные фильмы',
                            style: TextStyle(
                              color: colorScheme.onBackground,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // если список пустой, то выводим сообщеие об этом
                        _listMedia.isNotEmpty
                            ? createFavoritesList()
                            : const Text(
                                'У вас нет избранных фильмов',
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
    );
  }

  Widget createFavoritesList() {
    return SizedBox(
      width: double.infinity,
      //заполняем экран сеткой в 3 элемента
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          //тэг hero для анимации
          final heroTag = 'gridView$index${_listMedia[index].id}';
          return GestureDetector(
            onTap: () async {
              // ожидаем результат следующего экрана,
              // если в детальном экране медиа изменили статус фильма, то перестраиваем виджет
              final result = await Navigator.push(
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
              //перестраиваем виджет с новыми данными
              if (result) {
                getFavorite();
              }
            },
            // выводим ипостер фильма
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
}
