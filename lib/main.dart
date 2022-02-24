import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/screens/all_search_results.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import 'screens/bottom_page.dart';
import './screens/detailed_info.dart';
import './screens/full_movie_descrip.dart';
import 'widgets/videoPlayer.dart';

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
        routes: {
          DetailedInfo.routName: (context) => const DetailedInfo(),
          FullMovieDesciption.routNamed: (context) =>
              const FullMovieDesciption(),
          VideoPlayerScreen.routNamed: (context) => const VideoPlayerScreen(),
          AllSearchResult.routNamed: (context) => const AllSearchResult(),
        },
      ),
    );
  }
}
