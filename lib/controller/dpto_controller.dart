
import 'package:flutter/material.dart';
import '../classes/depto.dart';
import '../repository/depto_repository.dart';


class DeptoController {
  List<Dpto> lista=[];

  final repository = DeptoRepository();

  final state = ValueNotifier<DptoControllerState>(DptoControllerState.start);



  Future start() async {
    state.value = DptoControllerState.loading;
    try {

      lista = await repository.fetch();

    }catch (e) {
      state.value = DptoControllerState.error;
    }
    state.value = DptoControllerState.sucess;
  }

}
enum DptoControllerState{start, loading, sucess,error}