import 'package:flutter/material.dart';

//виджет для заголовка экрана входа в приложение
class LoginTitle extends StatelessWidget {
  const LoginTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //контейнер с лого
          Container(
            height: size.height * 0.2,
            width: size.width * 0.4,
            margin: const EdgeInsets.all(8.0),
            child: const Image(
              image: AssetImage(
                'assets/image/logo/kino_app_logo.png',
              ),
              fit: BoxFit.contain,
            ),
          ),

          //заголовок
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Поиск фильмов и сериалов',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
