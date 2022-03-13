import 'dart:ui';
import 'package:flutter/material.dart';

import '../screens/overview_movies_screns/genre_of_movies.dart';

//виджет для вывода скроллинга жанров
class ListViewOfGenres extends StatelessWidget {
  ListViewOfGenres({Key? key}) : super(key: key);

  //список жанров фильмов: id, name, imageUrl
  List<Map<String, dynamic>> listOfGenres = [
    {
      "id": 28,
      "name": "Боевик",
      'imageUrl': 'assets/image/genres/action_movie.jpg',
    },
    {
      "id": 12,
      "name": "Приключения",
      'imageUrl': 'assets/image/genres/adventure.jpg'
    },
    {
      "id": 16,
      "name": "Мультфильм",
      'imageUrl': 'assets/image/genres/animated.jpg'
    },
    {"id": 35, "name": "Комедия", 'imageUrl': 'assets/image/genres/comedy.jpg'},
    {
      "id": 80,
      "name": "Криминал",
      'imageUrl': 'assets/image/genres/criminal.jpg'
    },
    {
      "id": 99,
      "name": "Биография",
      'imageUrl': 'assets/image/genres/documentary.jpg'
    },
    {"id": 18, "name": "Драма", 'imageUrl': 'assets/image/genres/drama.jpg'},
    {
      "id": 10751,
      "name": "Семейный",
      'imageUrl': 'assets/image/genres/family.jpg'
    },
    {
      "id": 14,
      "name": "Фэнтези",
      'imageUrl': 'assets/image/genres/fantasy.jpg'
    },
    {
      "id": 36,
      "name": "История",
      'imageUrl': 'assets/image/genres/history.jpg'
    },
    {"id": 27, "name": "ужасы", 'imageUrl': 'assets/image/genres/horror.jpg'},
    {
      "id": 10402,
      "name": "Музыка",
      'imageUrl': 'assets/image/genres/music.jpg'
    },
    {
      "id": 9648,
      "name": "Детектив",
      'imageUrl': 'assets/image/genres/detectvie.jpg'
    },
    {
      "id": 878,
      "name": "Фантастика",
      'imageUrl': 'assets/image/genres/fantastic.jpg'
    },
    {
      "id": 53,
      "name": "Триллер",
      'imageUrl': 'assets/image/genres/thriller.jpg'
    },
    {
      "id": 10752,
      "name": "Военный",
      'imageUrl': 'assets/image/genres/military.jpg'
    },
    {
      "id": 37,
      "name": "Вестерн",
      'imageUrl': 'assets/image/genres/western.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' Фильмы по жанрам',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          padding: const EdgeInsets.only(top: 8),
          height: 250,
          child: ListView.builder(
            //внутренний горизонтальный скролл
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: listOfGenres.length,
            itemBuilder: (context, index) {
              //получаем жанр
              final genre = listOfGenres[index];
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
                      },
                    );
                  },
                  child: getGenreCard(size, genre['imageUrl'], genre['name']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

//виджет для вывода одной карточки с жанром
  Widget getGenreCard(
    Size size,
    String imageUrl,
    String genreName,
  ) {
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
