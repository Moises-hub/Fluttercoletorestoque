
import 'dart:convert';


import 'package:coliseucoletor/database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../classes/local.dart';

import 'local_dados.dart';

class Lista_Local extends StatefulWidget {
  final String depto;
  final String ip;
  final String port;

  const Lista_Local({super.key, required this.depto, required this.ip, required this.port});



  @override
  State<Lista_Local> createState() => _Lista_LocalState(depto,ip,port);
}

class _Lista_LocalState extends State<Lista_Local> {
  final String depto;
  final String ip;
  final String port;

  _Lista_LocalState(this.depto, this.ip, this.port);

  static DatabaseHelper? banco;
  List<Local> listaDeLcal = [];
  int tamanhoDaLista = 0;
  String valueText ='';

  TextEditingController _textFieldController = TextEditingController();


  void initState() {
    print('ip:$ip');
 _carregarLista();
  }

  _carregarLista() {
    banco = new DatabaseHelper();

    banco?.inicializaBanco();

    Future<List<Local>> listaDeLocal = banco!.getLlocal();

    listaDeLocal.then((novaListaDeLocal) {
      setState(() {
        this.listaDeLcal = novaListaDeLocal;

        this.tamanhoDaLista = novaListaDeLocal.length;
      });
    });

  }




  Future<void> _displayTextInputDialog(BuildContext context) async {

    return showDialog(

        context: context,
        builder: (context) {

          return AlertDialog(

            title: Text('Local'),
            content: TextField(

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
            actions: <Widget>[
              ElevatedButton(


                child: const Text('OK',style: TextStyle(color: Colors.black),),
                onPressed: () {
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                  setState(() {
                   _carregaTela(valueText);


                  });
                },
              ),


            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOCAL'),
        centerTitle: true,
        backgroundColor: CupertinoColors.darkBackgroundGray,
        actions: [Image.asset('assets/images/icone_coliseu.png')],
      ),
      body: Container(
        color: Colors.black12,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: tamanhoDaLista,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1.0,

              child: ListTile(
                  title: Column(children: [
                    Container(
                        color: Colors.deepPurple,
                        child: Row(children: const [
                          Text(
                            'LOCAL',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: CupertinoColors.white,
                                fontSize: 15),
                          )
                        ])),
                    Row(children: [
                      Text(
                        listaDeLcal[index].data_hora.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      )
                    ]),
                  ]),
                  subtitle:
                  Column(children: [
                    Text(listaDeLcal[index].local.toString()),
                    Text(listaDeLcal[index].status.toString(),
                        style: TextStyle(
                            color: getCor_Envio(listaDeLcal[index].status)))]),

                  leading: CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: Colors.deepPurple,
                    //getCor(listaDeBalanco[index].status),
                    child: Text(
                          listaDeLcal[index].data_hora![0] +
                          listaDeLcal[index].data_hora![1] +
                          '/' +
                          listaDeLcal[index].data_hora![2] +
                          listaDeLcal[index].data_hora![3],
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                  trailing: Wrap(// space between two icons
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              getIcondelete(listaDeLcal[index].status),
                              color: getCor_Delete(listaDeLcal[index].status),
                            ),
                            onPressed: () {
                              _excluir(listaDeLcal[index].status.toString(),
                                  listaDeLcal[index].data_hora.toString());
                            }),
                        IconButton(
                            icon: Icon(
                              getIconedit(listaDeLcal[index].status),
                              color: getCor_Edit(listaDeLcal[index].status),
                            ),
                            onPressed: () {
                              if (listaDeLcal[index].status != 'ENVIADO') {
                               _carregaTelaEdit(listaDeLcal[index].data_hora.toString(),listaDeLcal[index].local.toString());
                              }
                            }),
                        IconButton(
                            icon: Icon(
                              getIcon(listaDeLcal[index].status),
                              color: getCor_Envio(listaDeLcal[index].status),
                            ),
                            onPressed: () {

                                envio(index);
                                _carregarLista();

                            }) // icon-2
                      ])),

              //
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          _displayTextInputDialog(context);

        },

        //   },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        focusColor: Colors.blueGrey,
      ),
    );

  }


  _novaDataHora() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyyHHmmss').format(now);

    return formattedDate;
  }


  void _carregaTela(String local_p) {
    print(ip);

    Route route = MaterialPageRoute(
        builder: (context) =>
            LocalDados(dataHora: _novaDataHora(),depto: depto,local_P: local_p,ip: ip,port: port));
    Navigator.push(context, route).then((value) => _carregarLista());

  }

  void _carregaTelaEdit(String _eDataHora, String local) {
    Route route = MaterialPageRoute(
        builder: (context) => LocalDados(dataHora: _novaDataHora(),depto: depto,local_P: local,ip: ip,port: port));
    Navigator.push(context, route).then((value) => _carregarLista());
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
      return Icons.not_interested_sharp;
  }

  _excluir(String st,String dado) {
    if (st != 'ENVIADO') {
      showAlertDialog(dado, context);
    }
  }


  excluir(String d) {
    banco!.apagarLocal(d);
    _carregarLista();
    Navigator.of(context).pop();
  }

    showAlertDialog(String dado,BuildContext context) {
      Widget cancelButton =  ElevatedButton(
        child: Text("Sim"),
        onPressed: () => excluir(dado),
      );

      Widget continueButton =  ElevatedButton(
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

  _listarEnvio(int index)async {

    List<String> listar = [];
    Map<String, String>data = {};

    for (int i = 0; i < listaDeIt.length; i++) {
      String idprod = listaDeIt[i].idProduto.toString();

      String local = '';
      if (listaDeIt[i].local.toString() == '') {
        local = 'null';
      }
      else {
        local = listaDeIt[i].local.toString();
      }



      data.addAll({
        "id_depto": "$depto",
        "id_produto": "$idprod",
        "local": "$local",

      });
      print(data);
      listar.add(jsonEncode(data));
    }


    String body = listar.toString();
    final url = 'http://$ip:$port/local';
    var response = await http.post(
      (Uri.parse(url)),
      headers: {"Content-Type": "application/json"},
      body: body,
    );


    if (jsonDecode(response.body)[0]['executado'] == 'sucess') {
      banco!.atualizarStatusL(listaDeLcal[index].data_hora.toString());


      _carregarLista();
    }
  }


  List<Local> listaDeIt = [];

  envio(int index) async {


    Future<List<Local>> listaDeContatos = banco!.getListaLocalFiltro(
        listaDeLcal[index].data_hora.toString());

    listaDeContatos.then((novaListaDeContatos) {

      this.listaDeIt = novaListaDeContatos;
      _listarEnvio(index);
    });




  }
  }




