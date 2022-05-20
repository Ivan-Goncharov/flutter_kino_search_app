import 'dart:ui';
import 'package:flutter/material.dart';

import '../../models/media_models/map_of_genres_media.dart';
import '../../screens/overview_movies_screns/genre_of_movies.dart';

//виджет для вывода скроллинга жанров
class ListViewOfGenres extends StatelessWidget {
  final bool isMovie;
  ListViewOfGenres({Key? key, required this.isMovie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //список жанров фильмов: id, name, imageUrl
    List<Map<String, dynamic>> genres =
        isMovie ? GenresOfMedia.genresOfMovies : GenresOfMedia.genresOfTvShow;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //заголовок
        Text(
          isMovie ? 'Фильмы по жанрам' : 'Сериалы по жанрам',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),

        //скроллинг жанров
        Container(
          padding: const EdgeInsets.only(top: 8),
          height: 250,
          child: ListView.builder(
            //внутренний горизонтальный скролл
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: genres.length,
            itemBuilder: (context, index) {
              //получаем жанр
              final genre = genres[index];
              return Container(
                padding: const EdgeInsets.only(right: 16.0, left: 3),
                //обрабатываем нажатие
                //переходим на страницу с фильмами с этим жанром
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      GenresOfMovies.routNamed,
                      arguments: {
                        'genreName': genre['name'],
                        'genreId': genre['id'],
                        'mediaType': isMovie ? 'movie' : 'tv'
                      },
                    );
                  },
                  child: GenreCard(
                    imageUrl: genre['imageUrl'],
                    genreName: genre['name'],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//виджет для вывода одной карточки с жанром
class GenreCard extends StatelessWidget {
  //изображение
  final String imageUrl;
  //название жанра
  final String genreName;
  const GenreCard({Key? key, required this.imageUrl, required this.genreName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        //размытый постер жанра
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width * 0.5,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white38, width: 2),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imageUrl),
                  ),
                ),
              ),
            ),
          ),
        ),

        // название жанра
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width * 0.49),
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color.fromARGB(94, 56, 55, 55),
            ),
            child: Text(
              genreName,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
