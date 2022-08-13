
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:http/http.dart' as http;
import '../classes/local.dart';
import '../database/database_helper.dart';


class LocalDados extends StatefulWidget {
  final String dataHora;
  final String depto;
  final String ip;
  final String port;
  final String local_P;

  const LocalDados({super.key, required this.dataHora, required this.depto, required this.ip, required this.port, required this.local_P});

  @override
  State<LocalDados> createState() => _LocalDadosState(dataHora,depto,ip,port,local_P);
}

class _LocalDadosState extends State<LocalDados> {
  final String dataHora;
  final String depto;
  final String ip;
  final String port;
  final String local_P;

  _LocalDadosState(this.dataHora, this.depto, this.ip, this.port, this.local_P);


  final _formKey = new GlobalKey<FormState>();
  final _local = TextEditingController();
  final _formKey2 = new GlobalKey<FormState>();

  static DatabaseHelper? banco;

  List<Local> listaDeLocal =[];
  int tamanhoDaLista = 0;
  int cam = 0;
  int soma_itens = 0;
  String _scanBarcode = 'Unknown';
  String name = "";
  var _myController = TextEditingController();





  _carregarLista() {
    banco = new DatabaseHelper();

    banco?.inicializaBanco();

    Future<List<Local>> noteListFuture =
    banco!.getListaLocalFiltro(dataHora);
    noteListFuture.then((novaListaDeLocal) {
      setState(() {
        this.listaDeLocal = (novaListaDeLocal);

        // atribuo o novo tamanho a minha variavel local
        this.tamanhoDaLista = (novaListaDeLocal.length);
        soma_itens = tamanhoDaLista;
      });
    });
  }


  fetch() async {

    Random random = Random();


    // String tlocal;
    var url = 'http://$ip:$port/getprodutos/$depto/$name/';


    var response = await http.get((Uri.parse(url)));
    var json = jsonDecode(response.body);

    if (response.contentLength == 0 || json[0]['registro'] == '0')
      _prodNaoEncontrado(context);
    else {
      FlutterBeep.beep();
      final todasLinhas = await banco!.getBalancoMapProdDupliL(
          dataHora, json[0]['CODIGO_BARRA']);
      if (todasLinhas != 0) {
        final iD = await banco!.getBalancoMapProdDupliL(
            dataHora, json[0]['CODIGO_BARRA']);

        _carregarLista();
        _myController.clear();
        name = '';
      }
      else {
        if (soma_itens < 200) {
          var
          _localit = Local(
              data_hora: dataHora,
              codBarras: json[0]['CODIGO_BARRA'],
              idProduto: json[0]['ID_PRODUTO'],
              descricao: json[0]['DESCRICAO'],
              local: local_P,
              status: 'Não Enviado',
             depto: depto
              );

          banco!.inserirLocal(_localit);

          _myController.clear();
          name = '';
          _carregarLista();
        }
      }
    }
  }


  _prodNaoEncontrado(BuildContext context) {
    Widget OKButton =  FloatingActionButton(
        child: Text("Ok"), onPressed: () => Navigator.of(context).pop());
    _myController.clear();
    name = '';

    AlertDialog alert = AlertDialog(
      content: Text('PRODUTO NÃO ENCONTRADO!'),
      actions: [
        OKButton,
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

  @override
  void initState() {
_carregarLista();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: CupertinoColors.activeBlue),
        backgroundColor: Colors.white,
        title: TextField(
          controller: _myController,
          onEditingComplete: getEdt,
          decoration: const InputDecoration(hintText: 'Localizar'),
          onChanged: (val) => initiateSearch(val),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo_camera),
        onPressed: () => scanBarcodeNormal(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(child:  Column(
        children: [
          Expanded(
            child:ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: tamanhoDaLista,
              itemBuilder: (context, index) {
                return Dismissible(
                  // direction: DismissDirection.startToEnd,
                    key: ObjectKey(listaDeLocal[index]),
                    onDismissed: (startToEnd) =>
                        showAlertExclusao(listaDeLocal[index], index),
                    //  onDismissed: (startToEnd) => showAlertExclusao(listaDeBalanco[index], index),
                    background: swipeActionLeft(),
                    child: Card(
                        child: ListTile(
                          title: Center(
                              child: Text(
                                listaDeLocal[index].descricao.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )),
                          subtitle: Column(
                            children: [
                              Row(children: [
                                const Text('CÓDIGO DE BARRAS:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.blueAccent)),
                                Text(listaDeLocal[index].codBarras.toString(),
                                    style:const TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.bold)),
                              ]),
                              Row(children: [
                                Text('LOCAL: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.blue)),
                                if (listaDeLocal[index].local != null)
                                  Text(listaDeLocal[index].local.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ))
                                else

                                  const  Text('LOCAL: null',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        )),

                              ]),
                            ],
                          ),
                        )
                      //
                    ));
              },
            ),
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Column(
                children: [
                  SizedBox(
                      child: Text(
                        'Itens Adicionados',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        textAlign: TextAlign.right,
                      )),
                  SizedBox(child: somadeItens()),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget swipeActionLeft() => Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white));

  Widget swipeActionRigth() => Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.blue,
      child: const Icon(Icons.edit, color: Colors.white));





  showAlertExclusao(Local _bal, int dado) {
     FloatingActionButton(
        child: Text("Sim"),
        onPressed: () {
          _removerItem(_bal, dado);
          _carregarLista();
          Navigator.of(context).pop();
        });
  }

  void _removerItem(Local local, int index) {
    setState(() {
      listaDeLocal = List.from(listaDeLocal)..removeAt(index);

      banco!.apagarBalancoItem(int.parse(local.id.toString()));

      tamanhoDaLista = tamanhoDaLista - 1;
      soma_itens = tamanhoDaLista;
    });
  }


  getEdt() async {
    try {
      fetch();
      cam = 0;
    } on PlatformException {}
  }

  somadeItens() {
    return Text(
      soma_itens.toString(),
      style: TextStyle(fontSize: 31, color: Colors.black),
      textAlign: TextAlign.right,
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != '') {
        name = barcodeScanRes;
        fetch();
        barcodeScanRes = '';
      }
    });
  }
}
