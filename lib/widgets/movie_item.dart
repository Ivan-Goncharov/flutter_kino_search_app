import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:flutter_my_kino_app/models/movies_history.dart';
import 'package:flutter_my_kino_app/widgets/detailed_widget/getImage.dart';
import 'package:provider/provider.dart';

import '../providers/movie.dart';
import '../screens/detailed_movie_info.dart';

//виджет для вывода карточки с одним фильмом в поиске фильмов
class MovieItem extends StatelessWidget {
  //принимаем информацию о фильме в аргументе и выводим ее на экран
  final MediaBasicInfo movie;
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heroTag = 'movieItem${movie.id}';
    return GestureDetector(
      onTap: () {
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                transitionOnUserGestures: true,
                child: GetImage(
                  imageUrl: movie.imageUrl,
                  title: movie.title,
                  height: size.height * 0.15,
                  width: size.width * 0.2,
                ),
                tag: heroTag,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${movie.title}',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${movie.originalTitle}, ${movie.date}',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
