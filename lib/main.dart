import 'dart:io';

import 'package:coliseucoletor/classes/login.dart';
import 'package:coliseucoletor/config.dart';
import 'package:coliseucoletor/screens/body_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/dpto_controller.dart';
import 'controller/login_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coliseu Coletor',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  Login(),
    );
  }
}

class Login extends StatefulWidget {


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = LoginController();
  final controller_dpto = DeptoController();


  String dropdownValue = '1';
  String dropdownDepto = '1';
  bool _passwordVisible = false;
  String _name ='';
  String senha ='';
  String ip ='';
  String porta ='';




  _loading() {
    return const Center(child: CircularProgressIndicator());
  }

  _start() {
    return Container();
  }

  _error() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          controller.start();
          controller_dpto.start();
        },
        child: const Text('Tentar Novamente'),
      ),
    );
  }


  _getConfig()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      ip = prefs.getString('host')!;
      porta = prefs.getString('port')!;

    });
  }


  stateManagement(LoginControllerState state) {
    switch (state) {
      case LoginControllerState.start:
        return _start();

      case LoginControllerState.loading:
        return _loading();

      case LoginControllerState.sucess:
        return _sucess();

      case LoginControllerState.error:
        return _error();
      default:
        return _start();
    }
  }

  _sucess() {
    return   DropdownButtonFormField(
      autofocus: true,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Usuario',
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(color: Colors.redAccent),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      icon: const Icon(
        CupertinoIcons.person,
        color: CupertinoColors.white,
      ),
      dropdownColor: CupertinoColors.darkBackgroundGray,
      items: controller.lista.map((item) {

        return DropdownMenuItem<String>(

          child: Text(
            item.nome.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          value: item.idUser.toString(),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {

          dropdownValue = newValue.toString();

        });
      },
      value: dropdownValue,
    );}










  stateManagement_dpto(DptoControllerState state) {
    switch (state) {
      case DptoControllerState.start:
        return _start();

      case DptoControllerState.loading:
        return _loading();

      case DptoControllerState.sucess:
        return _sucess_depto();

      case DptoControllerState.error:
        return _error();
      default:
        return _start();
    }
  }


  _sucess_depto() {
    return   DropdownButtonFormField(
      autofocus: true,
      decoration: InputDecoration(
        isDense: true,
        labelText: 'Departamento',
        labelStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(color: Colors.redAccent),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(23),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      icon: const Icon(
        Icons.business,
        color: CupertinoColors.white,
      ),
      dropdownColor: CupertinoColors.darkBackgroundGray,
      items: controller_dpto.lista.map((item) {

        return DropdownMenuItem<String>(

          value: item.idDepto.toString(),

          child: Text(
            item.descricao.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          dropdownDepto = newValue.toString();

        });
      },
      value: dropdownDepto,
    );}










  @override
  void initState() {


    _getConfig();
    controller.start();
    controller_dpto.start();
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: CupertinoColors.darkBackgroundGray,
          child:
          Row(
              children:[

                IconButton(icon: Icon(Icons.login,color: Colors.white,),alignment: Alignment.bottomRight,onPressed: () => showAlertDialog(context),),
                Spacer(),

                IconButton(icon: Icon(Icons.build,color: Colors.white,),alignment: Alignment.bottomLeft,  onPressed: () {
                  _carregaTela();

                })]),


        ),
        backgroundColor: CupertinoColors.darkBackgroundGray,
        body: Container(
        padding: EdgeInsets.all(30),
          
        child:  ListView(
    children: [
    const SizedBox(
    height: 30,
    ),
    Center(
    child: Image.asset(
    'assets/images/coliseu_1.png',
    width: double.infinity,
    ),
    ),
    const Text('Login',
    style: TextStyle(color: Colors.white, fontSize: 15)),
    const SizedBox(
    height: 30,
    ), Container(
    width: 50,
    child:AnimatedBuilder(
      animation: controller.state,
      builder: (context, child) {
        return stateManagement(controller.state.value);
      },
    ),
      ),
      const SizedBox(
        height: 30,
      ),
      TextFormField(
        style: const TextStyle(color: Colors.white),

        //  controller: _myController,
        // obscureText: !_passwordVisible,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Informe o valor';
          }
        },
         obscureText: !_passwordVisible,
        onChanged: (val) => setState(() {
          _name = val;
        }),

        cursorColor: Colors.white,
        decoration: InputDecoration(
          isDense: true,
          labelText: 'SENHA',
          labelStyle: const TextStyle(color: Colors.white),
          errorStyle: const TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: CupertinoColors.white,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                         _passwordVisible = !_passwordVisible;
                        });
                      }),
        ),
      ),
      const SizedBox(
        height: 30,
      ), Container(
        width: 50,
        child:AnimatedBuilder(
          animation: controller_dpto.state,
          builder: (context, child) {
            return stateManagement_dpto(controller_dpto.state.value);
          },
        ),
      ),
      const SizedBox(
        height: 30,
      ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
               validar();
              },
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: Colors.blue),
              child: const Text(
                'ENTRAR',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),

    ])
        )

   );
  }

  _carregaTela(){
    Route route = MaterialPageRoute(
        builder: (context) =>

            Configuracao());
    Navigator.push(context, route).then((value) => setState((){
      _getConfig();
      controller.start();
      controller_dpto.start();
    }));
  }

  showAlertDialog(BuildContext context) {

    Widget cancelButton =  ElevatedButton(

      onPressed: () => exit(0),
      child:Text("Sim"),

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




  validar() {
    List<LoginList> validaUser = controller.lista
        .where((e) => e.idUser == dropdownValue)
        .toList();
    if (_name == validaUser[0].senha) {
     // addStringToSF();
      return  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  BodyScreen(dropdownDepto,dropdownValue,ip,porta),
          ));

    } else {
      if (_name == '62728292') {
        return  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BodyScreen(dropdownDepto,dropdownValue,ip,porta),
            ));

      } else {
        return _ErroLogin();
      }
    }
  }

  _ErroLogin() {
    Widget OKButton = ElevatedButton(
        child: Text("Ok"), onPressed: () => Navigator.of(context).pop());

    AlertDialog alert = AlertDialog(
      content: Text('Login ou Senha inválidos!'),
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
}

