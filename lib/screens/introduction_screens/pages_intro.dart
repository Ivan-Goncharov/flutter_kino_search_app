import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/screens/auth_screen/login_page.dart';

class PagesIntro1 extends StatelessWidget {
  final Widget lottieAnimation;
  final String title;
  final String subtitle;
  const PagesIntro1({
    required this.lottieAnimation,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0xFF6750A4),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          lottieAnimation,
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final pref = await SharedPreferences.getInstance();
              pref.setBool('showHome', true);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 85, top: 60),
              alignment: Alignment.center,
              child: const Text(
                'Начать',
                style: TextStyle(
                    color: Color(0xFF21005D),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              width: size.width * 0.5,
              height: size.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(0xFFEADDFF),
              ),
            ),
          )
        ],
      ),
    );
  }
}
