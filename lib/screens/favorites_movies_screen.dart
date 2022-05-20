import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../providers/movie.dart';
import '../models/firebase_models/favorite_movie.dart';
import '../widgets/system_widgets/error_message_widg.dart';
import '../widgets/media_widgets/favorite_movies.dart';

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

  //список любимых фильмов заполним позже
  List<MediaBasicInfo> _listMedia = [];

  @override
  void initState() {
    _favoriteMovie = FavoriteMovie();

    getFavorite();

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
      if (!mounted) return;
      if (value != null) {
        setState(() {
          _listMedia = value;
          _isLoading = false;
        });
      } else {
        setState(() => _isError = true);
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
                ? Center(
                    child: Lottie.asset(
                      'assets/animation_lottie/favorite_loading.json',
                      height: size.height * 0.7,
                      width: size.width * 0.7,
                    ),
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
                            ? FavoriteMoviesList(
                                listOfMedia: _listMedia,
                                changeList: getFavorite,
                              )
                            : Text(
                                'У вас нет избранных фильмов',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
