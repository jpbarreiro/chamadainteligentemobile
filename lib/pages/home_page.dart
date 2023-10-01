import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../widgets/logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget customCard(String label) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().appBar,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Logo(size: 100, inverted: true).logoIcon,
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: customCard('Minhas chamadas'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: customCard('Minhas turmas'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                  icon: Icon(Icons.logout),
                  label: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sair',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: Colors.deepOrange,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
