
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/balanco.dart';
import '../database/database_helper.dart';
import 'balanco_dados.dart';

/*
class ListaBalanco extends StatelessWidget {
  final String depto;
  final String _user;
  final String ip;
  final String porta;


  ListaBalanco(this.depto, this._user, this.ip, this.porta);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListaDeContatos(depto, _user),
    );
  }

  final String depto;
  final String _user;
  final String ip;
  final String porta;


}*/

class ListaBalanco extends StatefulWidget {
  final String depto;
  final String user;
  final String ip;
  final String porta;

  const ListaBalanco({super.key, required this.depto, required this.user, required this.ip, required this.porta});

  @override
  State<ListaBalanco> createState() => _ListaBalancoState(depto,user,ip,porta);
}

class _ListaBalancoState extends State<ListaBalanco> {
  final String depto;
  final String _user;
  final String ip;
  final String porta;


  String dropdownValue = '1';
  String valueText = '';
  TextEditingController _textFieldController = TextEditingController();
  static DatabaseHelper? banco;

  int tamanhoDaLista = 0;
  List<Balanco> listaDeBalanco = [];


  _ListaBalancoState(this.depto, this._user, this.ip, this.porta);

//  List<Balanco> listaDeBalancoEnvio = [];


  @override
  void initState() {
    banco = new DatabaseHelper();

    banco?.inicializaBanco();

    Future<List<Balanco>> listaDeContatos = banco!.getListaDeBalanco(depto);

    listaDeContatos.then((novaListaDeContatos) {
      setState(() {
        this.listaDeBalanco = novaListaDeContatos;

        this.tamanhoDaLista = novaListaDeContatos.length;
      });
    });
  }

  _carregarLista() {
    banco = new DatabaseHelper();
    banco?.inicializaBanco();

    Future<List<Balanco>> noteListFuture = banco!.getListaDeBalanco(depto);
    noteListFuture.then((novaListaDeContatos) {
      setState(() {
        this.listaDeBalanco = novaListaDeContatos;

        this.tamanhoDaLista = novaListaDeContatos.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BALANÇO'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [Image.asset('assets/images/icone_coliseu.png')],
      ),
      body: Container(
        color: Colors.black87,
        child: _listaDeContatos(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _type();
        },

        //   },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        focusColor: Colors.blueGrey,
      ),
    );
  }

  Future onGoBack(dynamic value) async {
    _carregarLista();
    setState(() {});
  }


  void _type() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("Selecione o Tipo de Balanço"),
            content: Container(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField(

                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),

                        items: dropdownItems_tipo,
                        value: dropdownValue,
                        decoration: const InputDecoration(

                          isDense: true,
                          labelText: 'TIPO',
                          labelStyle: TextStyle(
                              color: Colors.black, fontSize: 15),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                        ),


                        onChanged: (newVal) {
                          setState(() {
                            dropdownValue = newVal!;


                            Navigator.of(context).pop();
                            _type();
                          });
                        }),
                    Text(' '),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                        });
                      },
                      controller: _textFieldController,
                      decoration: const InputDecoration(
                        hintText: '',
                        labelText: 'Digite o Local',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();


                    _carregaTela();
                  }),
              ElevatedButton(
                  child: const Text("cancela"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _textFieldController.clear();
                  }),
            ]);
      },
    );
  }

  // _reenviaBalanco(String dt, type, depto, _user) async {
  //   var id = await banco.getIdMapListFilter(dt);
  //
  //   //  print(dt+' '+type+' '+depto+' '+_user+' '+id);
  //   banco.reSave(
  //       dt,
  //       type,
  //       '',
  //       depto,
  //       _user,
  //       id,
  //       _ip,
  //       _port);
  //   banco.atualizarStatus(dt, 'ENVIADO');
  //
  //   _carregarLista();
  // }
  //
  //
  // enviaBalanco(String dt, type, depto, _user) async {
  //   var id = await banco.getIdMapListFilter(dt);
  //
  //   //  print(dt+' '+type+' '+depto+' '+_user+' '+id);
  //   banco.Save(
  //       dt,
  //       type,
  //       '',
  //       depto,
  //       _user,
  //       id,
  //       _ip,
  //       _port);
  //   banco.atualizarStatus(dt, 'ENVIADO');
  //
  //   _carregarLista();
  // }

  Widget _listaDeContatos() {
    Balanco _balanco;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tamanhoDaLista,
      itemBuilder: (context, index) {
        return Card(
          elevation: 1.0,

          child: ListTile(
            title: Column(children: [
              Container(
                  color: getCor_Type(listaDeBalanco[index].tipo.toString()),
                  child: Row(children: [
                    getCor_Texto(listaDeBalanco[index].tipo.toString())

                  ])),
              Row(children: [
                Text(
                  listaDeBalanco[index].data_hora.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                )
              ]),
            ]),
            subtitle: Text(listaDeBalanco[index].status.toString(),
                style: TextStyle(
                    color: getCor_Envio(listaDeBalanco[index].status))),
            leading: CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.transparent,
              //getCor(listaDeBalanco[index].status),
              child: Text(
                listaDeBalanco[index].data_hora.toString()[0] +
                    listaDeBalanco[index].data_hora.toString()[1] +
                    '/' +
                    listaDeBalanco[index].data_hora.toString()[2] +
                    listaDeBalanco[index].data_hora.toString()[3],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
            trailing: _getListaIcone(listaDeBalanco[index].id.toString(),
                listaDeBalanco[index].tipo.toString(),
                listaDeBalanco[index].status.toString(),
                index)
            ,),

          //
        );
      },
    );
  }

  _getListaIcone(String idBal, String tipo, String status, int index) {
    if (status == 'ENVIADO') {
      return Wrap( // space between two icons
        children: <Widget>[

          IconButton(
              icon: Icon(
                getIconedit(status),
                color: getCor_Edit(status),
              ),
              onPressed: () {
                _carregaTelaEdit(idBal, '', tipo, status);
              }),
          IconButton(
            icon: Icon(
              getIcon(status),
              color: getCor_Envio(status),
            ),
            onPressed: () {
              envio(index);
            },),

          /*  IconButton(
            icon: Icon(
              Icons.cloud_done_rounded,
              color: Colors.blue,
            ),
            onPressed: () {
              /* _reenviaBalanco(_datah,
                  type, depto, _user);
              _carregarLista();*/

            },),*/
          // icon-2
        ],);
    }
    else {
      return Wrap( // space between two icons
        children: <Widget>[
          IconButton(
              icon: Icon(
                getIcondelete(status),
                color: getCor_Delete(status),
              ),
              onPressed: () {
                //  print(id);
                _excluir(status, idBal, index);
              }),
          IconButton(
              icon: Icon(
                getIconedit(status),
                color: getCor_Edit(status),
              ),
              onPressed: () {
                _carregaTelaEdit(
                    idBal, '', tipo, status);
              }),
          IconButton(
            icon: Icon(
              getIcon(status),
              color: getCor_Envio(status),
            ),
            onPressed: () {
              envio(index);
            },) // icon-2
        ],);
    }
  }

  void _carregaTelaEdit(String idBal, String local, String tipo,
      String status) {
    Route route = MaterialPageRoute(
        builder: (context) =>
            BalancoDados(idBalanco: idBal,
                local: local,
                dpto: depto,
                status: status,
                ip: ip,
                porta: porta));
    Navigator.push(context, route).then((value) => _carregarLista());
  }

  _excluiBalServidor(String id)async{
    var url = 'http://$ip:$porta/deletebalanco/$id/';
    var response = await http.get((Uri.parse(url)));

  }




  void _Excluir(String id, int index) {
    setState(() {
      listaDeBalanco = List.from(listaDeBalanco)
        ..removeAt(index);

      banco?.apagarBalanco(id);

      tamanhoDaLista = tamanhoDaLista - 1;

      _excluiBalServidor(id);


      Navigator.of(context).pop();
    });
  }

  showAlertDialog(String dado, BuildContext context, int index) {
    Widget cancelButton = ElevatedButton(
      child: Text("Sim"),
      onPressed: () => _Excluir(dado, index),
    );

    Widget continueButton = ElevatedButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Deseja Excluir o Registro Selecionado?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  _excluir(String dt, dado, int index) {
    if (dt != 'ENVIADO') {
      showAlertDialog(dado, context, index);
    }
  }


  _novaDataHora() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyyHHmmss').format(now);

    return formattedDate;
  }


  void _carregaTela() async {
    Map data = {

      "tipo": "$dropdownValue",
      "id_usuario": "$_user",
      "id_depto": "$depto"
    };



    String body = jsonEncode(data);
    final url = 'http://$ip:$porta/balanco/0';
    var response = await http.post(
      (Uri.parse(url)),
      headers: {"Content-Type": "application/json"},
      body: body,
    );


    var _balanco = Balanco(data_hora: _novaDataHora(),
        tipo: dropdownValue,
        id: jsonDecode(response.body)[0]['ID'],
        depto: depto,
        id_usuario: _user,
        status: 'Não Enviado'
    );
    setState(() {
      banco?.novoBalanco(_balanco);


      Route route = MaterialPageRoute(
          builder: (context) =>

              BalancoDados(dpto: depto,
                  local: valueText,
                  status: 'Não Enviado',
                  idBalanco: jsonDecode(response.body)[0]['ID'],
                  ip: ip,
                  porta: porta));
      Navigator.push(context, route).then((value) => _carregarLista());

      _textFieldController.clear();
    });
  }

  getCor_Texto(_string) {
    if (_string == '1')
      return Text('AJUSTE', style: TextStyle(
          fontWeight: FontWeight.w300,
          color: CupertinoColors.white,
          fontSize: 15),);
    else
      return Text('CONFERÊNCIA', style: TextStyle(
          fontWeight: FontWeight.w300,
          color: CupertinoColors.white,
          fontSize: 15),);
  }

  getCor_Type(_string) {
    if (_string == '2')
      return Colors.blue;
    else
      return CupertinoColors.activeGreen;
  }

  getCor_Envio(_string) {
    if (_string != 'ENVIADO')
      return Colors.blue;
    else
      return Colors.green;
  }

  getCor_Edit(_string) {
    if (_string != 'ENVIADO')
      return Colors.blue;
    else
      return Colors.grey;
  }

  getCor_Delete(_string) {
    if (_string != 'ENVIADO')
      return Colors.red;
    else
      return Colors.grey;
  }


  getIcon(_string) {
    if (_string == 'ENVIADO')
      return CupertinoIcons.cloud_upload_fill;
    else
      return CupertinoIcons.cloud_upload;
  }

  getIcondelete(_string) {
    if (_string != 'ENVIADO')
      return Icons.delete;
    else
      return Icons.not_interested_sharp;
  }

  getIconedit(_string) {
    if (_string != 'ENVIADO')
      return Icons.edit;
    else
      return Icons.search;
  }

  List<DropdownMenuItem<String>> get dropdownItems_tipo {
    List<DropdownMenuItem<String>> menuItems = [

      const DropdownMenuItem(
          value: "2",
          child: Text(
            "CONFERÊNCIA",
            style: TextStyle(fontSize: 15),
          )),
      const DropdownMenuItem(
          value: "1",
          child: Text(
            "AJUSTE",
            style: TextStyle(fontSize: 15),
          ))
    ];
    return menuItems;
  }

  _listarEnvio(int index)async {
    Map data_2 = {
      "tipo": "$dropdownValue",
      "id_usuario": "$_user",
      "id_depto": "$depto"
    };


    String body_2 = jsonEncode(data_2);
    final url_2 = 'http://$ip:$porta/balanco/' +
        listaDeBalanco[index].id.toString();
    var response_2 = await http.post(
      (Uri.parse(url_2)),
      headers: {"Content-Type": "application/json"},
      body: body_2,
    );









    List<String> listar = [];
    Map<String, String>data = {};
    for (int i = 0; i < listaDeIt.length; i++) {
      String idprod = listaDeIt[i].idProduto.toString();
      String cb = listaDeIt[i].codBarras.toString();
      String qnt = listaDeIt[i].qnt.toString();
      String local = '';
      if (listaDeIt[i].local.toString() == '') {
        local = 'null';
      }
      else {
        local = listaDeIt[i].local.toString();
      }
      String bal = listaDeIt[i].idBalanco.toString();


      data.addAll({"id_balanco": "$bal",
        "id_depto": "$depto",
        "id_produto": "$idprod",
        "codigo_barras": "$cb",
        "local": "$local",
        "qnt": "$qnt"
      });

      listar.add(jsonEncode(data));
    }

    String body = listar.toString();
    final url = 'http://$ip:$porta/itbalanco/' +
        listaDeBalanco[index].id.toString() + '/$depto';
    var response = await http.post(
      (Uri.parse(url)),
      headers: {"Content-Type": "application/json"},
      body: body,
    );


    if (jsonDecode(response.body)[0]['executado'] == 'sucess') {
      banco!.atualizarStatus(listaDeBalanco[index].id.toString());
      banco!.atualizarData(listaDeBalanco[index].id.toString(),_novaDataHora());


      _carregarLista();
    }
  }


  List<Balanco_itens> listaDeIt = [];

  envio(int index) async {


    Future<List<Balanco_itens>> listaDeContatos = banco!.getListaDeBalancoItens(
        listaDeBalanco[index].id.toString());

    listaDeContatos.then((novaListaDeContatos) {

      this.listaDeIt = novaListaDeContatos;
      _listarEnvio(index);
    });




  }


}