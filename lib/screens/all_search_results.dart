import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:provider/provider.dart';

import '../widgets/movie_item.dart';

class AllSearchResult extends StatefulWidget {
  static const routNamed = './allSearch';
  const AllSearchResult({Key? key}) : super(key: key);

  @override
  _AllSearchResultState createState() => _AllSearchResultState();
}

class _AllSearchResultState extends State<AllSearchResult> {
  List<Movie> _movies = [];
  String _searchText = '';
  late Movies _provider;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });

    _searchText = ModalRoute.of(context)!.settings.arguments as String;
    _provider = Provider.of<Movies>(context);

    _provider.searchAllMovie(_searchText).then(
      (_) {
        _movies = _provider.items;
        _movies.sort(
          (a, b) => b.voteCount!.compareTo(a.voteCount as int),
        );
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск: $_searchText'),
      ),
      body: _isLoading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Загружаем результаты'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return MovieItem(movie: _movies[index]);
                },
              ),
            ),
    );
  }
}
