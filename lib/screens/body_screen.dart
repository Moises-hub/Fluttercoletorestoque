
import 'dart:io';

import 'package:coliseucoletor/screens/list_produtos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list_balanco.dart';
import 'listalocal.dart';

class BodyScreen extends StatelessWidget {


  final String depto;
  final String _user;
  final String ip;
  final String porta;


  BodyScreen(this.depto, this._user, this.ip, this.porta);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          backgroundColor: CupertinoColors.darkBackgroundGray,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                alignment: Alignment.bottomRight,
                onPressed: () => showAlertDialog(context)),
          ],
        ),
        body: Container(
          color: CupertinoColors.darkBackgroundGray,
          child:
                HomeScreen(depto,_user,ip,porta),

        ));
  }
}

class HomeScreen extends StatelessWidget {
  final String depto;
  final String _user;
  final String ip;
  final String porta;


  HomeScreen(this.depto,  this._user, this.ip, this.porta );

  @override
  Widget build(BuildContext context) {
    return ListView(
      //  mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Image(image: AssetImage('images/coliseum.png'))),
        Card(
          color: CupertinoColors.darkBackgroundGray,
          child: Image.asset(
            'assets/images/coliseu_1.png',
            height: 125,
            width: double.infinity,
          ),
        ),

        SizedBox(
          height: 15,
        ),

        Container(
          color: CupertinoColors.darkBackgroundGray,
          width: MediaQuery.of(context).size.width - 10,
          height: 125,
          child: Card(
            shadowColor: Colors.blue,
            elevation: 2.0,
            color: CupertinoColors.black,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onPressed: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ListaBalanco(depto: depto, user: _user,ip: ip,porta: porta),
                  ),
                );
              },
              child: Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(CupertinoIcons.barcode, size: 25),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Balanço',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          height: 10,
        ),
        Container(
          color: CupertinoColors.darkBackgroundGray,
          width: MediaQuery.of(context).size.width - 10,
          height: 125,
          child: Card(
            shadowColor: Colors.blue,
            elevation: 2.0,
            color: CupertinoColors.black,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Lista_Local(depto: depto, ip: ip,port: porta),
                  ),
                );
              },
              child: Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(CupertinoIcons.collections, size: 25),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Local',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: CupertinoColors.darkBackgroundGray,
          width: MediaQuery.of(context).size.width - 10,
          height: 125,
          child: Card(
            shadowColor: Colors.blue,
            elevation: 2.0,
            color: CupertinoColors.black,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ListProdutos(depto: depto)
                )
              );

              },
              child: Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(CupertinoIcons.archivebox_fill, size: 25),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Produtos',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),

//balanço
      ],
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget cancelButton =  ElevatedButton(
    child: Text("Sim"),
    onPressed: () => exit(0),
  );

  Widget continueButton =  ElevatedButton(
    child: Text("Cancelar"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text("Deseja Realmente Sair da Aplicação?"),
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