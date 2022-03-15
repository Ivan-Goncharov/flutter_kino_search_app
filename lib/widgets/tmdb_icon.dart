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
        child: SvgPicture.network(
          'https://www.themoviedb.org/assets/2/v4/logos/v2/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg',
          color: const Color.fromARGB(160, 1, 179, 228),
        ),
      ),
    );
  }
}
