import 'package:flutter/material.dart';

import 'sign_in.dart';
import 'sign_up.dart';

// экран авторизации
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;
  @override
  //переключаем страницы, в завсимости от нажатой кнопки
  Widget build(BuildContext context) => _isLogin
      ? SignInPage(onCklickedSignUp: toogle)
      : SignUpPage(onCklickedSignIn: toogle);

  //экран зависит от того, какую кнопку нажал пользователь
  void toogle() => setState(() => _isLogin = !_isLogin);
}
