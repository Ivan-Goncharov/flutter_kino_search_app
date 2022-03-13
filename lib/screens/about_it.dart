import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Для описания сервиса
class AboutIt extends StatelessWidget {
  const AboutIt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        child: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          icon: Icon(Icons.exit_to_app),
        ),
      ),
    );
  }
}
