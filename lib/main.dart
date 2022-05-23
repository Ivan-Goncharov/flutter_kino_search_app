import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/my_theme.dart';
import '../models/firebase_models/favorite_movie.dart';
import '../providers/movies.dart';
import '../screens/auth_screen/login_page.dart';
import '../screens/auth_screen/password_reset.dart';
import '../screens/overview_movies_screns/genre_of_movies.dart';
import '../screens/movie_detailes_info/wath_providers_screen.dart';
import '../screens/cast_screens/all_actor_screen.dart';
import '../screens/cast_screens/all_crew_screen.dart';
import '../screens/all_search_results.dart';
import '../screens/bottom_page.dart';
import '../screens/movie_detailes_info/full_movie_descrip.dart';
import '../widgets/system_widgets/video_player.dart';
import '../widgets/system_widgets/custom_page_route.dart';

void main() async {
  //инициализируем FireBase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //подключаем провайдеры
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Movies(),
        ),
        ChangeNotifierProvider.value(
          value: FavoriteMovie(),
        ),
        ChangeNotifierProvider.value(
          value: ChangeThemeProvider(),
        ),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ChangeThemeProvider>(context);

        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeProvider.isDark ? MyTheme.darkTheme : MyTheme.lightTheme,

          //StreamBuilder обрабатывает вход в прилодение через FireBase
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const ErrorMessage();
              } else if (snapshot.hasData) {
                return const BottomPage();
              } else {
                return const LoginPage();
              }
            },
          ),

          //пути навигации, которые используются в приложении
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
              case WatchProvidersScreen.routNamed:
                return CustomPageRoute(
                  child: const WatchProvidersScreen(),
                  settings: settings,
                );
              case ResetPasswordScreen.routNamed:
                return CustomPageRoute(
                  child: const ResetPasswordScreen(),
                  settings: settings,
                );
              case GenresOfMovies.routNamed:
                return CustomPageRoute(
                  child: const GenresOfMovies(),
                  settings: settings,
                );
            }
          },
        );
      },
    );
  }
}

//ошибка при доступе к firebase
class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Column(
        children: const [
          Text(
            'У нас что-то сломалось',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Му уже решаем проблему. Возможно, проблемы с интернет соединением. Попробуйте еще раз обновить',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
