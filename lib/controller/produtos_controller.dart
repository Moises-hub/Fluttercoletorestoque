import 'package:coliseucoletor/classes/produtos.dart';
import 'package:flutter/material.dart';
import '../repository/produtosrepository.dart';

class ProdutoController {
  List<Produtos> lista=[];

  final repository = ProdutoRepository();

  final state = ValueNotifier<ProdutoControllerState>(ProdutoControllerState.start);



  Future start(String depto, String cb) async {
    state.value = ProdutoControllerState.loading;
    try {

      lista = await repository.fetch(depto,cb);

    }catch (e) {
      state.value = ProdutoControllerState.error;
    }
    state.value = ProdutoControllerState.sucess;
  }

}
enum ProdutoControllerState{start, loading, sucess,error}