import 'dart:io';

import 'package:coliseucoletor/classes/local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import '../classes/balanco.dart';

class DatabaseHelper with ChangeNotifier {
  static DatabaseHelper _databaseHelper = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  String tabelaNome = 'balanco';
  String colId = 'id';
  String colData_Hora = 'data_hora';
  String colIdUser = 'id_usuario';
  String colTipo = 'tipo';
  String colStatus = 'status';
  String colDepto = 'depto';
  String tabelaItens = 'balancoprod';
  String colIdBalanco = 'idBalanco';
  String colIdItem = 'idItem';
  String colIdProduto = 'id_produto';
  String colCodigo_barra = 'codigo_barra';
  String colDescricao = 'descricao';
  String colQnt = 'qnt';
  String colLocal = 'local';

  //local
  String tabelaNomeL = 'local';
  String colIdL = 'id';
  String colData_HoraL = 'data_hora';
  String colIdLProdutoL = 'id_produto';
  String colCodigo_barraL = 'codigo_barra';
  String colDescricaoL = 'descricao';
  String colLocalL = 'local';
  String colStatusL = 'status';
  String colDeptoL = 'depto';





  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await inicializaBanco();
    }

    return _database;
  }


  Future<Database> inicializaBanco() async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String path = diretorio.path + 'balanco_app.db';


    var listadeBalanco =
    await openDatabase(path, version: 1, onCreate: _criaBanco);
    return listadeBalanco;
  }

  void _criaBanco(Database db, int versao) async {
    await db.execute('CREATE TABLE $tabelaNome('
        '$colId  TEXT,'
        '$colData_Hora  TEXT,'
        '$colIdUser TEXT,'
        '$colDepto TEXT,'
        '$colTipo  TEXT,'
        '$colStatus  TEXT'
        ');');
    await db.execute('CREATE TABLE $tabelaItens('
        '$colIdBalanco  TEXT,'
        '$colIdItem  INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colIdProduto  TEXT,'
        '$colCodigo_barra  TEXT,'
        '$colDescricao  TEXT,'
        '$colQnt  REAL,'
        '$colLocal  TEXT '
        ');');

    await db.execute('CREATE TABLE $tabelaNomeL('
        '$colIdL   INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colIdLProdutoL  TEXT,'
        '$colData_HoraL TEXT,'
        '$colCodigo_barraL  TEXT,'
        '$colDescricaoL  TEXT,'
        '$colLocalL  TEXT ,'
        '$colDeptoL TEXT,'
        '$colStatusL TEXT'
        ');');
  }

  Future<List<Map<String, Object?>>?> getBalancoMapListFilter(
      String id_balanco) async {
    Database? db = await this.database;
    var result = await db?.rawQuery(
        "SELECT * FROM $tabelaItens WHERE $colIdBalanco = '$id_balanco' order by $colId desc");
    return result;
  }

  Future<List<Map<String, Object?>>?> getBalancoMapList(String depto) async {
    Database? db = await this.database;
    var result = await db?.rawQuery(
        "SELECT * FROM $tabelaNome where $colDepto ='$depto'   order by $colId desc");
    return result;
  }

  Future<List<Balanco>> getListaDeBalanco(String depto) async {
    var balancoMapList = await getBalancoMapList(depto);
    int? count = balancoMapList?.length;
    List<Balanco> listaDeBalanco = [];
    for (int i = 0; i < count!; i++) {
      listaDeBalanco.add(Balanco.fromMapObject(balancoMapList![i]));
    }
    return listaDeBalanco;
  }

  novoBalanco(Balanco balanco) async {
    Database? db = await this.database;

    var result = await db?.insert(tabelaNome, balanco.toMap());
    return result;
  }

  apagarBalanco(String _id) async {
    var db = await this.database;
    int? result = await db?.rawDelete(
        "DELETE FROM $tabelaNome WHERE $colId = '$_id'");

  }


  Future<List<Map<String, dynamic>>> getBalancoMapItensListFilter(
      String _idBalanco) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT * FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco' order by $colIdItem desc");
    return result;
  }


  Future<List<Balanco_itens>> getListaDeBalancoItens(String _idBalanco) async {
    var balancoMapItensList = await getBalancoMapItensListFilter(_idBalanco);
    int count = balancoMapItensList.length;

    List<Balanco_itens> listaDeBalItens = [];
    for (int i = 0; i < count; i++) {
      listaDeBalItens.add(Balanco_itens.fromMapObject(balancoMapItensList[i]));
    }
    return listaDeBalItens;
  }

  Future<Object?> getQntItens(String _idBalanco) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT SUM($colQnt)as soma FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco'");


    return result[0]["soma"];
  }

  Future<Object?> getBalancoMapProdDupli(String _idBalanco,
      String _codBarra) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco' and $colCodigo_barra = '$_codBarra'");
    return result[0]["COUNT(*)"];
  }


  getBalancoLocal(String _idBalanco, String _codBarra) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT $colLocal FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco' and $colCodigo_barra = '$_codBarra'");
    var dbItem = result.first;

    return dbItem['local'];
  }

  Future<double?> getBalancoMapProdqtd(String _idBalanco,
      String _codBarra) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT $colQnt FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco' and $colCodigo_barra = '$_codBarra'");
    return double.parse(result[0]["$colQnt"].toString());
  }


  getBalancoMapProdUpi(String _idBalanco, String _codBarra) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT $colIdItem FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco' and $colCodigo_barra = '$_codBarra'");

    return result[0]["$colIdItem"].toString();
  }

  apagarBalancoIt(String _idBalanco, String _IdItem) async {
    var db = await this.database;
    int? result = await db?.rawDelete(
        "DELETE FROM $tabelaItens WHERE $colIdBalanco = '$_idBalanco' and   $colIdItem = '$_IdItem' ");
  }

  novoBalancoIt(Balanco_itens balanco) async {
    Database? db = await this.database;

    var result = await db?.insert(tabelaItens, balanco.toMap());
    return result;
  }

  atualizarStatus(String idBalanco) async {
    var db = await this.database;
    var result = await db!.rawUpdate(
        "UPDATE $tabelaNome SET $colStatus = 'ENVIADO' WHERE $colId = '$idBalanco'");
  }

  atualizarData(String idBalanco, String data) async {
    var db = await this.database;
    var result = await db!.rawUpdate(
        "UPDATE $tabelaNome SET $colData_Hora = '$data' WHERE $colId = '$idBalanco'");
  }



  //local

  Future<int> inserirLocal(Local local) async {
    Database? db = await this.database;
    var result = await db!.insert(tabelaNomeL, local.toMap());
    return result;
  }


  Future<List<Local>> getLlocal() async {
    var balancoMapList = await getLocalMapList();
    int count = balancoMapList.length;
    List<Local> listaDeLocal = [];
    for (int i = 0; i < count; i++) {
      listaDeLocal.add(Local.fromMapObject(balancoMapList[i]));
    }
    return listaDeLocal;
  }

  Future<List<Map<String, Object?>>> getLocalMapList() async {
    Database? db = await this.database;
    var result = await db!.rawQuery(
        "SELECT DISTINCT($colData_HoraL),$colStatusL,$colLocalL FROM $tabelaNomeL order by $colIdL desc");
    return result;
  }


  Future<List<Local>> getListaLocalFiltro(String datahora) async {
    var balancoMapList = await getLocalMapListFilter(datahora);
    int count = balancoMapList.length;

    List<Local> listaDeBal = [];
    for (int i = 0; i < count; i++) {
      listaDeBal.add(Local.fromMapObject(balancoMapList[i]));
    }
    return listaDeBal;
  }


  Future<List<Map<String, Object?>>> getLocalMapListFilter(String _dataHora) async {
    Database? db = await this.database;
    var result = await db!.rawQuery(
        "SELECT * FROM $tabelaNomeL WHERE $colData_HoraL = '$_dataHora' order by $colIdL desc");
    return result;
  }

  Future<Object?> getLocalMapProdUpi(
      Local local, String _dataHora, _codBarra) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT $colIdL FROM $tabelaNomeL WHERE $colData_HoraL = '$_dataHora' and $colCodigo_barraL = '$_codBarra'");
    var dbItem = result.first;
    return dbItem['id'];
  }

  Future<Object?> getBalancoMapProdDupliL(String dataHora, String _codBarra) async {
    Database? db = await this.database;

    var result = await db!.rawQuery(
        "SELECT COUNT(*) FROM $tabelaNomeL WHERE $colData_HoraL = '$dataHora' and $colCodigo_barraL = '$_codBarra'");
    return result[0]["COUNT(*)"];
  }

  apagarLocal(String dataHora) async {
    var db = await this.database;
    int result = await db!.rawDelete("DELETE FROM $tabelaNomeL WHERE $colData_HoraL = '$dataHora'");

  }

  apagarBalancoItem(int _id) async {
    var db = await this.database;
    int result =
    await db!.rawDelete("DELETE FROM $tabelaNomeL WHERE $colIdL = $_id ");

  }

  atualizarStatusL(String datahora) async {
    var db = await this.database;
    var result = await db!.rawUpdate(
        "UPDATE $tabelaNomeL SET $colStatusL = 'ENVIADO' WHERE $colData_HoraL = '$datahora'");
  }

}