import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:flutter_my_kino_app/widgets/movie_item.dart';
import 'package:provider/provider.dart';

class SearchMovieScreen extends StatefulWidget {
  const SearchMovieScreen({Key? key}) : super(key: key);

  @override
  _SearchMovieScreenState createState() => _SearchMovieScreenState();
}

class _SearchMovieScreenState extends State<SearchMovieScreen> {
  //контроллер и функция для прослушивания изменений в текстовом поле
  final _myTextController = TextEditingController();
  late Movies _movieProvider;
  List<Movie> movie = [];

  @override
  void initState() {
    _myTextController.addListener(_inputTextChange);
    super.initState();
  }

  void _inputTextChange() async {
    try {
      await _movieProvider.searchMovie(_myTextController.text);
    } catch (er) {
      print('Найдена ошибка $er');
    } finally {
      changeText();
    }
  }

  void changeText() {
    setState(() {
      movie = _movieProvider.items;
    });
  }

  @override
  void didChangeDependencies() {
    _movieProvider = Provider.of<Movies>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var text = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск фильмов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                hintText: 'Введите название фильма',
              ),
              controller: _myTextController,
            ),
            // SizedBox.expand(),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return MovieItem(movie: movie[index]);
                },
                itemCount: movie.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
