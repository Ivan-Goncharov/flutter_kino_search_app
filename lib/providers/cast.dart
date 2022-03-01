import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ItemCastInfo {
  final int id;
  ItemCastInfo(this.id);

  String _birthday = '';
  String get birthday {
    return _birthday;
  }

  int _age = 0;
  String get age {
    return '$_age лет';
  }

  String _deathday = '';
  String get deathday {
    return _deathday;
  }

  Future getCastInfo() async {
    try {
      final url = Uri.parse(
          'https://api.themoviedb.org/3/person/$id?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final castInfo = json.decode(response.body);
        print(castInfo['deathday']);
        print(castInfo['birthday']);
      }
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception: ${e.toString()}");
        rethrow;
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
      } else
        print("Unhandled exception: ${e.toString()}");
    }
  }
}
