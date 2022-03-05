import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/all_actor_screen.dart';
import './screens/all_crew_screen.dart';
import './screens/all_search_results.dart';
import './widgets/custom_page_route.dart';
import './screens/bottom_page.dart';
import './screens/full_movie_descrip.dart';
import './widgets/detailed_widget/videoPlayer.dart';
import '../providers/movies.dart';

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
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFA7391F),
            onPrimary: Color(0xFFFFFFFF),
            primaryContainer: Color(0xFFFFDAD0),
            onPrimaryContainer: Color(0xFF3D0500),
            secondary: Color(0xFF006689),
            onSecondary: Color(0xFFFFFFFF),
            secondaryContainer: Color(0xFFBFE8FF),
            onSecondaryContainer: Color(0xFF001E2C),
            tertiary: Color(0xFF7D5260),
            onTertiary: Color(0xFFFFFFFF),
            tertiaryContainer: Color(0xFFFFD8E4),
            onTertiaryContainer: Color(0xFF31111D),
            error: Color(0xFFB3261E),
            errorContainer: Color(0xFFF9DEDC),
            onError: Color(0xFFFFFFFF),
            onErrorContainer: Color(0xFF410E0B),
            background: Color(0xFFFDFBFF),
            onBackground: Color(0xFF1B1B1D),
            surface: Color(0xFFFDFBFF),
            onSurface: Color(0xFF1B1B1D),
            surfaceVariant: Color(0xFFE7E0EC),
            onSurfaceVariant: Color(0xFF49454F),
            outline: Color(0xFF79747E),
            onInverseSurface: Color(0xFFF1F0F4),
            inverseSurface: Color(0xFF2F3033),
            inversePrimary: Color(0xFFFFB4A0),
            shadow: Color(0xFF000000),
          ),
        ),
        darkTheme: ThemeData(
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFFFFB4A0),
              onPrimary: Color(0xFF640E00),
              primaryContainer: Color(0xFF862108),
              onPrimaryContainer: Color(0xFFFFDAD0),
              secondary: Color(0xFF72D1FF),
              onSecondary: Color(0xFF003549),
              secondaryContainer: Color(0xFF004C68),
              onSecondaryContainer: Color(0xFFBFE8FF),
              tertiary: Color(0xFFEFB8C8),
              onTertiary: Color(0xFF492532),
              tertiaryContainer: Color(0xFF633B48),
              onTertiaryContainer: Color(0xFFFFD8E4),
              error: Color(0xFFF2B8B5),
              errorContainer: Color(0xFF8C1D18),
              onError: Color(0xFF601410),
              onErrorContainer: Color(0xFFF9DEDC),
              background: Color(0xFF1B1B1D),
              onBackground: Color(0xFFE3E2E6),
              surface: Color(0xFF1B1B1D),
              onSurface: Color(0xFFE3E2E6),
              surfaceVariant: Color(0xFF49454F),
              onSurfaceVariant: Color(0xFFCAC4D0),
              outline: Color(0xFF938F99),
              onInverseSurface: Color(0xFF1B1B1D),
              inverseSurface: Color(0xFFE3E2E6),
              inversePrimary: Color(0xFFA7391F),
              shadow: Color(0xFF000000),
            ),
            fontFamily: 'Roboto'),
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
