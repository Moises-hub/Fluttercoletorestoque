import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../classes/balanco.dart';
import '../database/database_helper.dart';
import 'package:http/http.dart' as http;

class BalancoDados extends StatefulWidget {
  final String idBalanco;
  final String local;
  final String status;
  final String dpto;
  final String ip;
  final String porta;


  const BalancoDados({super.key, required this.idBalanco, required this.local, required this.status, required this.dpto, required this.ip, required this.porta});


  @override
  State<BalancoDados> createState() => _BalancoDadosState(idBalanco,local,status,dpto,ip,porta);
}

class _BalancoDadosState extends State<BalancoDados> {
  final String idBalanco;
  String local;
  final String status;
  final String depto;
  String qnttotal ='';
  String name = "";
  static String valueText ='';
  static String llocal ='';
  final String ip;
  final String porta;





  var _myController = TextEditingController();
  var _textFieldController = TextEditingController();
  final _local = TextEditingController();
  var _qnt = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  _BalancoDadosState(this.idBalanco, this.local, this.status, this.depto, this.ip, this.porta);


  int soma_itens =0;

  static DatabaseHelper? banco;
  int tamanhoDaLista = 0;
  int cam = 0;
  List<Balanco_itens> listaDeBalanco = [];

  @override
  void initState() {

    banco = new DatabaseHelper();

    banco!.inicializaBanco();

    Future<List<Balanco_itens>> listaDeItens =
    banco!.getListaDeBalancoItens(idBalanco);

    listaDeItens.then((novaListaDeBalanco) {
      setState(() {
        this.listaDeBalanco = novaListaDeBalanco;
        this.tamanhoDaLista = novaListaDeBalanco.length;
        soma_itens = tamanhoDaLista;
       somarQnt();
        _carregarLista();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottonQnt(),
      appBar: AppBar(


          iconTheme: IconThemeData(color: CupertinoColors.activeBlue),
          backgroundColor: Colors.white,
          actions: [

            TextButton(
              child: Text(
                'Alterar Local',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                _displayTextInputDialog(context);
              },
            ),

          ],
          title: busca(status)),
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: () => scanBarcodeNormal(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child:  _listaDeBalanco(),




      ),
    );
  }
  Widget _listaDeBalanco() {

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tamanhoDaLista,
      itemBuilder: (context, index) {
        return Dismissible(
          // direction: DismissDirection.startToEnd,
            key: ObjectKey(listaDeBalanco[index]),
            onDismissed: (startToEnd) =>
                showAlertExclusao(listaDeBalanco[index].iditem.toString()),
            //  onDismissed: (startToEnd) => showAlertExclusao(listaDeBalanco[index], index),
            background: swipeActionLeft(),
            child: Card(
                child: ListTile(
                  onLongPress: () => _atualizarBalanco(
                      listaDeBalanco[index].iditem.toString(),index),
                  title: Center(
                      child: Text(
                        listaDeBalanco[index].descricao.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )),
                  subtitle: Column(
                    children: [
                      Row(children: [
                        Text('CÓDIGO DE BARRAS:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blueAccent)),
                        Text(listaDeBalanco[index].codBarras.toString(),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ]),
                      Row(children: [
                        Text('LOCAL: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blue)),
                        if (listaDeBalanco[index].local != null)
                          Text(listaDeBalanco[index].local.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ))
                        else
                          const Text('LOCAL: null',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              )),
                      ]),
                    ],
                  ),
                  trailing: Card(
                    child: Column(children: [
                      const Text('Quantidade',
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                      Text(listaDeBalanco[index].qnt.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: CupertinoColors.activeBlue))
                    ]),
                  ),
                )
              //
            ));
      },
    );
  }


  showAlertExclusao(String _idItem) {
    if (status == 'ENVIADO') {
      _carregarLista();
      ShowAlertNaoExclusao();
    } else {
      Widget cancelButton =  ElevatedButton(
          child: Text("Sim"),
          onPressed: () {
            _removerItem(_idItem);
            _carregarLista();
            Navigator.of(context).pop();
          });

      Widget continueButton = ElevatedButton(
        child: Text("Cancelar"),
        onPressed: () {
          Navigator.of(context).pop();
          _carregarLista(); // dismiss dialog
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        content: Text("Deseja Excluir o Registro Selecionado"),
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
  }

  void _removerItem(String _id) {
    setState(() {
      //listaDeBalanco = List.from(listaDeBalanco)..removeAt(index);

      banco?.apagarBalancoIt(idBalanco,_id);

      tamanhoDaLista = tamanhoDaLista - 1;
    });
  }

  ShowAlertNaoExclusao() {
    AlertDialog alert = AlertDialog(
      content: Text(" item ja enviado não pode ser excluido!"),
      actions: [
        ElevatedButton(

            child: Text('OK',style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
      child: Icon(Icons.edit, color: Colors.white));


  busca(_string) {
    if (_string != 'ENVIADO') {
      return TextField(
        controller: _myController,
        onEditingComplete: getEdt,
        decoration: InputDecoration(hintText: 'Localizar'),
        onChanged: (val) => initiateSearch(val),
      );
    }
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();

    });
  }


  _carregarLista() {
    totaLisar();
    banco = new DatabaseHelper();

    banco!.inicializaBanco();

    Future<List<Balanco_itens>> listaDeItens =
    banco!.getListaDeBalancoItens(idBalanco);

    listaDeItens.then((novaListaDeBalanco) {
      setState(() {
        this.listaDeBalanco = novaListaDeBalanco;
        this.tamanhoDaLista = novaListaDeBalanco.length;
        soma_itens = tamanhoDaLista;
        somarQnt();
        _listaDeBalanco();
      });
    });

  }


  totaLisar() {
    somarQnt();
    return Text(qnttotal,style: TextStyle(fontSize: 30, color: Colors.blue,fontWeight: FontWeight.bold));
  }

  somarQnt() async {
    Balanco_itens _balancoIt;
    var retorna = await banco!.getQntItens(idBalanco);
    if (retorna == null) {
      qnttotal = '0';
    } else {
      qnttotal = retorna.toString();
    }

  }

  Future<void> scanBarcodeNormal() async {
    var  barcodeScanRes;
    if (status != 'ENVIADO')
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != '') {
        print(barcodeScanRes);
        name = barcodeScanRes;

        fetch();
        _carregarLista();
        barcodeScanRes = '';
      }
    });
  }


  _prodNaoEncontrado(BuildContext context) {
    Widget OKButton =  ElevatedButton(
        child: Text("Ok"), onPressed: () => Navigator.of(context).pop());
    _myController.clear();
    name = '';
    // set up the AlertDialog
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


  _proDivergLocal(BuildContext context, String _local) {
    Widget OKButton =  ElevatedButton(
        child: const Text("Ok"), onPressed: () => Navigator.of(context).pop());
    _myController.clear();
    name = '';
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text('PRODUTO COM LOCAL JA CADASTRADO! LOCAL "' + _local),
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

  getEdt() async {
    try {
      fetch();

      _carregarLista();
      cam = 0;
    } on PlatformException {}
  }



  fetch() async {

    Random random = Random();


    // String tlocal;
    var url = 'http://$ip:$porta/getprodutos/$depto/$name/';


    var response = await http.get((Uri.parse(url)));
    var json = jsonDecode(response.body);
    if (response.contentLength == 0||json[0]['registro'] == '0')
      _prodNaoEncontrado(context);

    else {
      if (valueText == null||valueText == ''|| valueText == ' ')
        llocal = json[0]['LOCAL'];

      else
        llocal = valueText;

      if (json[0]['LOCAL'] == ' ')
        llocal = '';
      FlutterBeep.beep();
      final todasLinhas = await banco!.getBalancoMapProdDupli(
          idBalanco, json[0]['CODIGO_BARRA']);

      if (todasLinhas! != 0) {
        var divergenciaLocal = await banco!.getBalancoLocal(
            idBalanco, json[0]['CODIGO_BARRA']);

        if (divergenciaLocal != valueText) {

            _proDivergLocal(context, divergenciaLocal);

            llocal = divergenciaLocal;

        }
        else {
          llocal = valueText;
        }
        var _qtd = await banco!.getBalancoMapProdqtd(
            idBalanco, json[0]['CODIGO_BARRA']);

        var iD = await banco!.getBalancoMapProdUpi(idBalanco, json[0]['CODIGO_BARRA']);

        //  soma_itens = int.parse(banco.getQntBalanco(_balanco, dataHora).toString());

        _myController.clear();
        name = '';
        var qnt = 1+_qtd!;
        banco!.apagarBalancoIt(idBalanco,iD);
        var _balancoIT = Balanco_itens(
            codBarras: json[0]['CODIGO_BARRA'],
           // iditem: random.nextInt(100),
            idBalanco: idBalanco,
            idProduto: json[0]['ID_PRODUTO'],
            local: llocal,
            descricao: json[0]['DESCRICAO'],
            qnt: 1+_qtd,
        );




        _myController.clear();
        name = '';
        banco!.novoBalancoIt(_balancoIT);
        //  soma_itens = int.parse(banco.getQntBalanco(_bbalanco, dataHora).toString());
        //   print(soma_itens.toString());
        setState((){
        _carregarLista();
        });
      } else {
        if (valueText == null)
          llocal = json[0]['LOCAL'];
        else if (valueText == '')
          llocal = json[0]['LOCAL'];
        else
          llocal = valueText;

        if (json[0]['LOCAL'] == null) llocal = '';
        if (soma_itens < 400) {
          var _balancoIT = Balanco_itens(
                              codBarras: json[0]['CODIGO_BARRA'],
                              idBalanco: idBalanco,
                              idProduto: json[0]['ID_PRODUTO'],
                              local: llocal,
                              descricao: json[0]['DESCRICAO'],
                              qnt: 1,
                              );
          _myController.clear();
          name = '';
          banco!.novoBalancoIt(_balancoIT);
        } else {
          return _alertLimite();
        }
      }
    }
    setState(() {
      _carregarLista();
    });
  }


  _alertLimite() {
    Widget OKButton =  ElevatedButton(
        child: Text("Ok"), onPressed: () => Navigator.of(context).pop());
    _myController.clear();
    name = '';
    AlertDialog alert = AlertDialog(
      content: Text('Limite de Itens alcançado!'),
      actions: [
        OKButton,
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }






  Widget _bottonQnt() {
    return BottomAppBar(
      color: Colors.white,
      elevation:20,
      child: Container(
        height: 60,
        padding: EdgeInsets.only(left: 10,bottom: 0,right: 10,top: 5),
        child: Row(

          children: [

            Column(
              children: [
                SizedBox(
                    child: Text(
                      'Quantidade',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.left,
                    )),
                SizedBox(
                  child: totaLisar(),
                ),
                //somarQnt()
              ],
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                    child: Text(
                      'Itens Adicionados',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.right,
                    )),
                SizedBox(child: somadeItens()),
                //somarQnt()
              ],
            ),
          ],
        ),
      ),
    );
  }

  somadeItens() {
    return Text(
      soma_itens.toString(),
      style: const TextStyle(fontSize: 30, color: Colors.black),
      textAlign: TextAlign.right,
    );
  }


  Future<void> _displayTextInputDialog(BuildContext context) async {
    if (status == 'ENVIADO') {
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Local'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    if (value.length > 0)
                      valueText = value;
                    else {
                      _textFieldController.clear();
                      valueText = '';
                    }
                  });
                },
                controller: _textFieldController,
                decoration: new InputDecoration(
                  hintText: '',
                  labelText: 'Digite Novo Local',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(

                    child: Text('OK',style: TextStyle(color:Colors.black),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    }
  }




  void _atualizarBalanco(String _id,int index) {
    if (status == 'ENVIADO') {
    } else {
      _local.text =listaDeBalanco[index].local.toString();
      _qnt.text = listaDeBalanco[index].qnt.toString();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Atualizar Balanço"),
              content:  Container(
                child:  Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    TextFormField(
                    controller: _local,
                    validator: (valor) {
                      //   if (valor.isEmpty && valor.length == 0) {
                      //    return "Campo Obrigatório";
                      // }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Local',
                      labelText: 'local',
                      border: OutlineInputBorder(),
                    ),
                  ),
                      Divider(
                        color: Colors.transparent,
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _qnt,
                        keyboardType: TextInputType.number,
                        validator: (valor) {
                          if (valor!.isEmpty && valor.length == 0) {
                            return "Campo Obrigatório";
                          }
                          ;
                        },
                        decoration: const InputDecoration(
                          hintText: '',
                          labelText: 'Qnt',
                          border: OutlineInputBorder(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: <Widget>[

                  ElevatedButton(
                  child: const Text("Atualizar"),
                  onPressed: () {




                    banco!.apagarBalancoIt(idBalanco,_id);
                    var _balancoIT = Balanco_itens(
                       codBarras: listaDeBalanco[index].codBarras,
                      idBalanco: listaDeBalanco[index].idBalanco,
                      idProduto: listaDeBalanco[index].idProduto,
                      local:_local.text,
                      descricao:listaDeBalanco[index].descricao,
                      qnt: double.tryParse(_qnt.text),
                    );




                    banco!.novoBalancoIt(_balancoIT);
                    setState((){
                    _carregarLista();
                    });
                    Navigator.of(context).pop();
                    // banco.atualizarBalancoQtd(_balanco, _id, double.tryParse(_qnt.text)-1);

                    //carrego a lista com os novos valores

                    // retiro o alerta da tela
                  },
                ),
              ],
            );
          });
    }
  }







}




