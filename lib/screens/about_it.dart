import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/tmdb_icon.dart';

/// Для описания сервиса
class AboutIt extends StatefulWidget {
  const AboutIt({Key? key}) : super(key: key);

  @override
  State<AboutIt> createState() => _AboutItState();
}

class _AboutItState extends State<AboutIt> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final instanse = FirebaseAuth.instance;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createTitle('O сервисе', theme.textTheme.displayMedium),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Данный сервис позволяет вам  искать различные фильмы и сериалы. '
                  'Выбирайте любимого провайдера и наслаждайтесь самыми яркими и интересными картинами. \n'
                  'Если вы не знаете, что сегодня посмотреть, откройте вкладку "обзор" и там вы найдете сотни популярных фильмов на любой вкус',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              createTitle(
                  'Все данные взяты с сервиса', theme.textTheme.displayMedium),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child:
                    TmdbIcon(link: 'https://www.themoviedb.org/?language=ru'),
              ),
              createTitle('Выход из профиля', theme.textTheme.displayMedium),
              GestureDetector(
                  onTap: () async {
                    await instanse.signOut();
                  },
                  child: createLogOutButton(theme, size))
            ],
          ),
        ),
      ),
    );
  }

  Container createLogOutButton(ThemeData theme, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.colorScheme.primaryContainer),
      width: size.width * 0.5,
      height: size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Выход',
            style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          const SizedBox(
            width: 20,
          ),
          Icon(
            Icons.logout_outlined,
            color: theme.colorScheme.onPrimaryContainer,
          )
        ],
      ),
    );
  }

  Padding createTitle(String title, TextStyle? style) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: style,
        ),
      );
}
