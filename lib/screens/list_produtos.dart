import 'package:coliseucoletor/controller/produtos_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ListProdutos extends StatefulWidget {
  final String depto;

  const ListProdutos({super.key, required this.depto});

  @override
  State<ListProdutos> createState() => _ListProdutosState(depto);
}

class _ListProdutosState extends State<ListProdutos> {
  final String depto;

  _ListProdutosState(this.depto);

  int cam = 0;
  String _scanBarcode = 'Unknown';
  String name = "0";
  var _myController = TextEditingController();
  final controller = ProdutoController();

  _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  _start() {
    return Container();
  }

  _error() {
    return _prodNaoEncontrado(context);
  }

  stateManagement(ProdutoControllerState state) {
    switch (state) {
      case ProdutoControllerState.start:
        return _start();

      case ProdutoControllerState.loading:
        return _loading();

      case ProdutoControllerState.sucess:
        return _sucess();

      case ProdutoControllerState.error:
        return _error();
      default:
        return _start();
    }
  }

  _sucess() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.lista.length,
      itemBuilder: (context, index) {
        return Card(
            elevation: 10,
            color: Colors.white,
            child: ListTile(
              leading: const CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: Colors.transparent,
                  //getCor(listaDeBalanco[index].status),
                  child: Icon(
                    CupertinoIcons.archivebox,
                    size: 20,
                    color: Colors.black54,
                  )),
              title: Text(
                controller.lista[index].dESCRICAO.toString(),
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                children: [
                  Row(children: [
                    const Text('CÓDIGO DE BARRAS:  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87)),
                    Text(controller.lista[index].cODIGOBARRA.toString(),
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                  ]),
                  Row(children: [
                    const Text('LOCAL:  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87)),
                    if (controller.lista[index].lOCAL != null)
                      Text(controller.lista[index].lOCAL.toString(),
                          style: const TextStyle(
                              //  fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black))
                    else
                      const Text('',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                  ]),
                ],
              ),
            )
            //

            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.white,
          title: TextField(
            controller: _myController,
            onEditingComplete: getEdt,
            decoration: const InputDecoration(hintText: 'Localizar'),
            onChanged: (val) => initiateSearch(val),
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.photo_camera),
          onPressed: () => scanBarcodeNormal(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: AnimatedBuilder(
          animation: controller.state,
          builder: (context, child) {
            return stateManagement(controller.state.value);
          },
        ));
  }

  getEdt() async {
    try {
      controller.start(depto, name);
      cam = 0;
    } on PlatformException {}
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
        // getPrd();
        controller.start(depto, name);
        barcodeScanRes = '';
      }
    });
  }
}
