import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movies.dart';
import 'screens/bottom_page.dart';

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
        // routes: {
        //   MovieScreen.routName: (context) => MovieScreen(),
        // },
      ),
    );
  }
}
