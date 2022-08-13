import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../classes/produtos.dart';

class ProdutoRepository extends ChangeNotifier {
  Future<List<Produtos>> fetch(String depto,String cb) async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _ip= prefs.getString('host')!;
    String _porta= prefs.getString('port')!;


    final url = 'http://$_ip:$_porta/getprodutos/$depto/$cb';

    var resposta = await http.get((Uri.parse(url)));


    final lista = List<dynamic>.from(jsonDecode(resposta.body));

    List<Produtos> tudo = [];
    for (var json_2 in lista) {
      final todo = Produtos.fromJson(json_2);
      tudo.add(todo);
    }

    return tudo;
  }
  @override
  notifyListeners();
}