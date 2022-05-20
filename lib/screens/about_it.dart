import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/system_widgets/switch_theme.dart';
import '../widgets/system_widgets/tmdb_icon.dart';

// Страница для описания сервисе
class AboutIt extends StatefulWidget {
  const AboutIt({Key? key}) : super(key: key);

  @override
  State<AboutIt> createState() => _AboutItState();
}

class _AboutItState extends State<AboutIt> {
  @override
  Widget build(BuildContext context) {
    final instanse = FirebaseAuth.instance;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ChapterTitle(title: 'O сервисе'),

              //описание сервиса
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Данный сервис позволяет вам  искать различные фильмы и сериалы. '
                  'Выбирайте любимого провайдера и наслаждайтесь самыми яркими и интересными картинами. \n'
                  'Если вы не знаете, что сегодня посмотреть, откройте вкладку "Обзор" и там вы найдете сотни популярных фильмов на любой вкус',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              //ссылка на иконку TMDB
              const ChapterTitle(title: 'Все данные взяты с сервиса'),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child:
                    TmdbIcon(link: 'https://www.themoviedb.org/?language=ru'),
              ),

              //cмена темы
              const ChapterTitle(title: 'Смена темы'),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SwitchThemeMode(),
                  ],
                ),
              ),

              //кнопка выхода с профиля
              const ChapterTitle(title: 'Выход из профиля'),
              GestureDetector(
                onTap: () async {
                  await instanse.signOut();
                },
                child: const LogOutButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//Заголовок раздела
class ChapterTitle extends StatelessWidget {
  final String title;
  const ChapterTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }
}

//кнопка выхода из приложения
class LogOutButton extends StatelessWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _colors.primaryContainer),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Выход',
            style: TextStyle(
                color: _colors.onPrimaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          const SizedBox(
            width: 20,
          ),
          Icon(
            Icons.logout_outlined,
            color: _colors.onPrimaryContainer,
          )
        ],
      ),
    );
  }
}
