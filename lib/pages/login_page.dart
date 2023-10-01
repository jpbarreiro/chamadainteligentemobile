import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../widgets/logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget credentialForm(String artigo, String formulario, {bool? obscure}) { // permite NULL
    return TextFormField(
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

  Widget loginButton() {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, Routes.home);
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
                child: credentialForm('o', 'Usuário'),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: alturaTela / 30,
                    right: larguraTela / 5,
                    left: larguraTela / 5),
                child: credentialForm('a', 'Senha', obscure: true),
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
