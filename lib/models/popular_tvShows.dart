import '../providers/movie.dart';

class PopularTvShowsModel {
  List<MediaBasicInfo> _popularTvShows = [];
  List<MediaBasicInfo> get popularTvShows => _popularTvShows;

  List<MediaBasicInfo> _topRatedTvShow = [];
  List<MediaBasicInfo> get topRatedTvShow => _topRatedTvShow;

  List<MediaBasicInfo> _nowPlayTvShow = [];
  List<MediaBasicInfo> get nowPlayTvShow => _nowPlayTvShow;

  List<MediaBasicInfo> _upcomingMovies = [];
  List<MediaBasicInfo> get upcommingMovies => _upcomingMovies;
}
