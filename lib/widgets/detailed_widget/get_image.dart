import 'package:flutter/material.dart';

//виджет для вывода изображения одного постера фильма
// ignore: must_be_immutable
class GetImage extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final double height;
  final double width;
  double? titleFontSize = 14;

  GetImage(
      {required this.imageUrl,
      required this.title,
      required this.height,
      required this.width,
      this.titleFontSize,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //если постера нет, то выводим системное изображение с названием фильма
    if (imageUrl!.contains('noImageFound')) {
      return Material(
        type: MaterialType.transparency,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Color.fromARGB(206, 41, 40, 40),
            alignment: Alignment.center,
            height: height,
            width: width,
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: titleFontSize),
            ),
          ),
        ),
      );

      //если есть, то выводим постер
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(
          image: NetworkImage('https://image.tmdb.org/t/p/w300$imageUrl'),
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
