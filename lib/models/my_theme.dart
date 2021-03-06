import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//провайдер для изменения цветовой темы
class ChangeThemeProvider with ChangeNotifier {
  //переменная, которая отслеживает, какая тема выбрана
  late bool _isDark;
  //объект класса для работы с sharedPreference
  late ThemePreference _themePreference;

  //в конструкторе инициализируем данные
  ChangeThemeProvider() {
    //по умолчанию тема светлая
    _isDark = false;
    _themePreference = ThemePreference();
    //получаем данные о том, какая тема выбрана
    getPreference();
  }

  //геттер
  bool get isDark => _isDark;

  //сеттер
  //присваиваем новое значение переменной
  //сохраняем данные с помощью sharedPreferences
  set isDark(bool value) {
    _isDark = value;
    _themePreference.setTheme(value);
    notifyListeners();
  }

  //метод для получения текущего выбора пользователя
  //true - темная
  // false - светлая
  void getPreference() {
    _themePreference.getTheme().then((value) {
      _isDark = value;
      notifyListeners();
    });
  }
}

//класс для работы c SharedPref.
class ThemePreference {
  static const preferKey = 'pref_key';

  //метод для сохранения текущего выбора пользователя
  Future<void> setTheme(bool value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferKey, value);
  }

  //метод для получения текущего выбора пользователя
  Future<bool> getTheme() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferKey) ?? false;
  }
}

//класс для хранения двух тем приложения
class MyTheme {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6750A4),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFEADDFF),
      onPrimaryContainer: Color(0xFF21005D),
      secondary: Color(0xFF7D5260),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE8DEF8),
      onSecondaryContainer: Color(0xFF1D192B),
      tertiary: Color.fromARGB(255, 172, 106, 128),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFD8E4),
      onTertiaryContainer: Color(0xFF31111D),
      error: Color(0xFFB3261E),
      errorContainer: Color(0xFFF9DEDC),
      onError: Color(0xFFFFFFFF),
      onErrorContainer: Color(0xFF410E0B),
      background: Color(0xFFFFFBFE),
      onBackground: Color(0xFF1C1B1F),
      surface: Color(0xFFFFFBFE),
      onSurface: Color(0xFF1C1B1F),
      surfaceVariant: Color(0xFFE7E0EC),
      onSurfaceVariant: Color(0xFF49454F),
      outline: Color(0xFF79747E),
      onInverseSurface: Color(0xFF1C1B1F),
      inverseSurface: Color(0xFF313033),
      inversePrimary: Color(0xFFD0BCFF),
      shadow: Color.fromARGB(181, 230, 222, 222),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        color: Color(0xFF1C1B1F),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromRGBO(255, 180, 160, 1),
      onPrimary: Color(0xFF640E00),
      primaryContainer: Color(0xFF862108),
      onPrimaryContainer: Color(0xFFFFDAD0),
      secondary: Color(0xFF72D1FF),
      onSecondary: Color(0xFF003549),
      secondaryContainer: Color(0xFF004C68),
      onSecondaryContainer: Color(0xFFBFE8FF),
      tertiary: Color(0xFFEFB8C8),
      onTertiary: Color(0xFF492532),
      tertiaryContainer: Color(0xFF633B48),
      onTertiaryContainer: Color(0xFFFFD8E4),
      error: Color(0xFFF2B8B5),
      errorContainer: Color(0xFF8C1D18),
      onError: Color(0xFF601410),
      onErrorContainer: Color(0xFFF9DEDC),
      background: Color(0xFF1B1B1D),
      onBackground: Color(0xFFE3E2E6),
      surface: Color(0xFF1B1B1D),
      onSurface: Color(0xFFE3E2E6),
      surfaceVariant: Color(0xFF49454F),
      onSurfaceVariant: Color(0xFFCAC4D0),
      outline: Color(0xFF938F99),
      onInverseSurface: Colors.white54,
      inverseSurface: Colors.white38,
      inversePrimary: Color(0xFFA7391F),
      shadow: Color.fromARGB(0, 20, 20, 20),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        color: Colors.white38,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
