import 'package:flutter/material.dart';

import '../models/favorite_movie.dart';
import '../providers/movie.dart';
import '../widgets/detailed_widget/getImage.dart';
import '../screens/movie_detailes_info/detailed_movie_info.dart';

// Экран для вывода избранных фильмов и сериалов
class FavoritesMoviesScreen extends StatefulWidget {
  const FavoritesMoviesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesMoviesScreen> createState() => _FavoritesMoviesScreenState();
}

class _FavoritesMoviesScreenState extends State<FavoritesMoviesScreen> {
  //получаем
  FavoriteMovie? _favoriteMovie;
  bool _isLoading = false;

  //
  List<MediaBasicInfo> _listMedia = [];

  @override
  void initState() {
    _favoriteMovie = FavoriteMovie();

    getFavorite();
    super.initState();
  }

  void getFavorite() {
    _listMedia = [];
    setState(() {
      _isLoading = true;
    });
    _favoriteMovie!.getAndFetchFavoriteNote().then(
          (value) => setState(() {
            _listMedia = value;
            _isLoading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: _isLoading
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
    return Container(
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          final heroTag = 'gridView$index${_listMedia[index].id}';
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    return DetailedInfoScreen(
                      movie: _listMedia[index],
                      heroTag: heroTag,
                    );
                  }),
                  transitionDuration: const Duration(milliseconds: 700),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                ),
              );
              if (result) {
                getFavorite();
              }
            },
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
