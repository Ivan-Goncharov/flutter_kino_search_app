import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/screens/all_actor_screen.dart';
import 'package:flutter_my_kino_app/screens/all_crew_screen.dart';
import 'package:flutter_my_kino_app/screens/all_search_results.dart';
import 'package:flutter_my_kino_app/widgets/custom_page_route.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import 'screens/bottom_page.dart';
import './screens/full_movie_descrip.dart';
import 'widgets/detailed_widget/videoPlayer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Movies(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const BottomPage(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case FullMovieDesciption.routNamed:
              return MaterialPageRoute(
                builder: (context) => const FullMovieDesciption(),
                settings: settings,
              );
            case VideoPlayerScreen.routNamed:
              return CustomPageRoute(
                child: const VideoPlayerScreen(),
                settings: settings,
              );
            case AllSearchResult.routNamed:
              return MaterialPageRoute(
                builder: (context) => const AllSearchResult(),
                settings: settings,
              );
            case AllActorScreen.routNamed:
              return CustomPageRoute(
                child: const AllActorScreen(),
                settings: settings,
              );
            case AllCrewScreen.routNamed:
              return CustomPageRoute(
                child: const AllCrewScreen(),
                settings: settings,
              );
          }
        },
        // routes: {
        //   // DetailedInfo.routName: (context) => const DetailedInfo(),
        //   FullMovieDesciption.routNamed: (context) =>
        //       const FullMovieDesciption(),
        //   VideoPlayerScreen.routNamed: (context) => const VideoPlayerScreen(),
        //   AllSearchResult.routNamed: (context) => const AllSearchResult(),
        //   AllActorScreen.routNamed: (context) => const AllActorScreen(),
        //   AllCrewScreen.routNamed: (context) => const AllCrewScreen(),
        // },
      ),
    );
  }
}
