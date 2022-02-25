import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/models/credits_info.dart';

import '../../providers/movie.dart';

class ActorCast extends StatelessWidget {
  final CreditsMovieInfo? creditsInfo;
  final double height;
  ActorCast({
    Key? key,
    required this.height,
    required this.creditsInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actors = creditsInfo?.cast;
    final lenghtActorsList = actors?.length ?? 0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Актеры',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$lenghtActorsList',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: height * 0.25,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final actor = actors![index];

              return actorInfo(actor);
            },
            itemCount: lenghtActorsList > 10 ? 10 : lenghtActorsList,
          ),
        ),
      ],
    );
  }

  Container actorInfo(Cast actor) {
    return Container(
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              image: getImage(actor.profilePath),
              height: 100,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5.0),
      width: 110,
    );
  }

  ImageProvider getImage(String? path) {
    if (path == null) {
      return const AssetImage('assets/image/noImageFound.png');
    } else {
      return NetworkImage('https://image.tmdb.org/t/p/w185$path');
    }
  }
}
