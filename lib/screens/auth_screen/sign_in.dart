import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/screens/auth_screen/password_reset.dart';

class SignInPage extends StatelessWidget {
  // контроллеры для полей ввода логина и пароля
  final _loginController = TextEditingController();
  final _passwordContoller = TextEditingController();

  final VoidCallback onCklickedSignUp;

  SignInPage({required this.onCklickedSignUp, Key? key}) : super(key: key);

// метод для авторизации на Firebase
  Future signIn(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _loginController.text.trim(),
            password: _passwordContoller.text.trim(),
          )
          .then(
            (_) => Navigator.of(context).popUntil((route) => route.isFirst),
          );
    } on FirebaseAuthException catch (e) {
      if (e.toString().contains('The password is invalid')) {
        _showSnackBar(context, 'Неверный пароль');
      } else if (e
          .toString()
          .contains('There is no user record corresponding')) {
        _showSnackBar(context, 'Пользователь с таким email не найден');
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  // метод для вывода сообщения об ошибке
  void _showSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(
          error,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
    );
  }

  // cтиль текста для заголовков
  TextStyle _textStyle() {
    return const TextStyle(
      color: Colors.white54,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrHeight = MediaQuery.of(context).size.height;
    final scrWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(title: const Text('Вход'), centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: scrHeight * 0.2,
                        width: scrWidth * 0.4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/image/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                ),

                Text(
                  'Электронная почта',
                  style: _textStyle(),
                ),
                //  Ввод логина
                Container(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 16,
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: _loginController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _loginController.clear();
                              },
                              icon: const Icon(
                                Icons.clear_rounded,
                              ),
                            )
                          : const SizedBox(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _loginController,
                  ),
                ),

                Text(
                  'Пароль',
                  style: _textStyle(),
                ),

                //Ввод пароля
                Container(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 16,
                  ),
                  child: TextField(
                    autocorrect: false,
                    obscureText: true,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: _passwordContoller.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _passwordContoller.clear();
                              },
                              icon: const Icon(
                                Icons.clear_rounded,
                              ),
                            )
                          : const SizedBox(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _passwordContoller,
                  ),
                ),

                //  кнопка войти
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              signIn(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: scrWidth * 0.4,
                              height: scrHeight * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              child: Text(
                                'ВОЙТИ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: (() => Navigator.pushNamed(
                          context, ResetPasswordScreen.routNamed)),
                      child: const Text('Забыли пароль?',
                          style: TextStyle(fontSize: 16)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Нет аккаунта?',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: onCklickedSignUp,
                          child: const Text('Создать аккаунт',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}