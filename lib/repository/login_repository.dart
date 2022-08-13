import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/login.dart';

class LoginRepository extends ChangeNotifier {
  Future<List<LoginList>> fetch() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _ip= prefs.getString('host')!;
    String _porta= prefs.getString('port')!;


    final url = 'http://$_ip:$_porta/getusers/';
    print(url);
    var resposta = await http.get((Uri.parse(url)));


    final lista = List<dynamic>.from(jsonDecode(resposta.body));

    List<LoginList> tudo = [];
    for (var json_2 in lista) {
      final todo = LoginList.fromJson(json_2);
      tudo.add(todo);
    }

    return tudo;
  }
  @override
  notifyListeners();
}