import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/detailed_widget/get_image.dart';

import '../providers/movie.dart';
import '../models/movies_history.dart';
import '../screens/movie_detailes_info/detailed_movie_info.dart';

//виджет для вывода карточки с одним фильмом/сериалом в поиске
class SearchItem extends StatelessWidget {
  //принимаем информацию о фильме в аргументе и выводим ее на экран
  final MediaBasicInfo movie;
  final MovieHistory movieHistory;
  final String typeScroll;
  final bool isSearch;
  const SearchItem({
    Key? key,
    required this.movie,
    required this.movieHistory,
    required this.typeScroll,
    required this.isSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heroTag = 'movieItem$typeScroll${movie.id}';
    return GestureDetector(
      onTap: () {
        //добавляем фильм в историю просмотров
        if (isSearch) {
          movieHistory.addMovie(movie);
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return DetailedInfoScreen(
                movie: movie,
                heroTag: heroTag,
              );
            }),
            transitionDuration: const Duration(milliseconds: 700),
            reverseTransitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Hero(
          child: GetImage(
            imageUrl: movie.imageUrl,
            title: movie.title,
            height: size.height * 0.15,
            width: size.width * 0.35,
          ),
          tag: heroTag,
        ),
      ),
    );
  }
}
