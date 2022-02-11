import 'dart:ui';

import 'package:flutter/material.dart';

import '../providers/movie.dart';

class DetailedInfo extends StatelessWidget {
  const DetailedInfo({Key? key}) : super(key: key);
  static const routName = '/detailed_info';

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final myHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('${movie.title}'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: myHeight * 0.60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/original${movie.imageUrl}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: 320,
                  bottom: 86,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                          'https://image.tmdb.org/t/p/original${movie.imageUrl}'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.40,
            maxChildSize: 0.9,
            minChildSize: 0.3,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
