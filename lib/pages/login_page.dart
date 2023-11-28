import 'dart:convert';

import 'package:chamadainteligentemobile/services/chamadainteligente_api.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();

  Widget credentialForm(String artigo, String formulario, TextEditingController controller,{bool? obscure}) { // permite NULL
    return TextFormField(
      controller: controller,
      obscureText: obscure ?? false, // parametro esconder senha, ternário simplicado
      cursorColor: Colors.indigo,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.indigo,
      ),
      decoration: InputDecoration(
        hintText: 'Informe $artigo $formulario...',
        hintStyle: TextStyle(color: Colors.indigo),
        border: OutlineInputBorder(),
        labelText: formulario,
        labelStyle: TextStyle(color: Colors.indigo),
      ),
    );
  }

  login() async {
    var res = await http.post(
      Uri(
        scheme: ChamadaInteligenteAPI.scheme,
        host: ChamadaInteligenteAPI.host,
        path: '${ChamadaInteligenteAPI.path}/user',
        port: ChamadaInteligenteAPI.port
      ),
      body: jsonEncode({"user": {"id": user.value.text, "password": password.value.text}}),
      headers: {'Content-Type': 'application/json'}
    );
    if(mounted){
      if(res.body == "User not found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuário não encontrado")));
      } else if(res.body == "Wrong password") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Senha incorreta")));
      } else if (res.statusCode==200) {
        AuthUser().login(jsonDecode(res.body));
        Navigator.pushNamed(context, Routes.home);
      }
    }
  }

  Widget loginButton() {
    return ElevatedButton.icon(
      onPressed: () {
        login();
      },
      icon: Icon(Icons.login),
      label: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Entrar',
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Logo(size: alturaTela / 5, inverted: true).logoIcon,
              Padding(
                padding: EdgeInsets.only(
                    top: alturaTela / 10,
                    right: larguraTela / 5,
                    left: larguraTela / 5),
                child: credentialForm('o', 'Usuário', user),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: alturaTela / 30,
                    right: larguraTela / 5,
                    left: larguraTela / 5),
                child: credentialForm('a', 'Senha', password, obscure: true),
              ),
              Padding(
                padding: EdgeInsets.only(top: alturaTela / 20),
                child: loginButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
