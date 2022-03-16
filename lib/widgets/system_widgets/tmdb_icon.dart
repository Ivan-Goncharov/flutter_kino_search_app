import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

//виджет для вывода иконки tmdb и ссылки на него
class TmdbIcon extends StatelessWidget {
  final String link;
  const TmdbIcon({Key? key, required this.link}) : super(key: key);

  // метод для перехода по ссылкам
  _launchURLBrowser(String urlAdress) async {
    final url = urlAdress;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 4),
      width: size.width * 0.28,
      height: size.height * 0.14,
      child: GestureDetector(
        onTap: (() {
          _launchURLBrowser(link);
        }),
        child: SvgPicture.asset(
          'assets/image/tmdb_icon.svg',
        ),
      ),
    );
  }
}
