import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:flutter_my_kino_app/widgets/detailed_widget/getImage.dart';
import 'package:provider/provider.dart';

import '../providers/movie.dart';
import '../models/movies_history.dart';
import '../screens/movie_detailes_info/detailed_movie_info.dart';

//виджет для вывода карточки с одним фильмом/сериалом в поиске
class SearchItem extends StatelessWidget {
  //принимаем информацию о фильме в аргументе и выводим ее на экран
  final MediaBasicInfo movie;
  final MovieHistory movieHistory;
  const SearchItem({
    Key? key,
    required this.movie,
    required this.movieHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heroTag = 'movieItem${movie.id}';
    return GestureDetector(
      onTap: () {
        //добавляем фильм в историю просмотров
        movieHistory.addMovie(movie);
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