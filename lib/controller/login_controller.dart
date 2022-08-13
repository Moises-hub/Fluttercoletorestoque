
import 'package:flutter/material.dart';

import '../classes/login.dart';
import '../repository/login_repository.dart';

class LoginController {
  List<LoginList> lista=[];

  final repository = LoginRepository();

  final state = ValueNotifier<LoginControllerState>(LoginControllerState.start);



  Future start() async {
    state.value = LoginControllerState.loading;
    try {

      lista = await repository.fetch();

    }catch (e) {
      state.value = LoginControllerState.error;
    }
    state.value = LoginControllerState.sucess;
  }

}
enum LoginControllerState{start, loading, sucess,error}