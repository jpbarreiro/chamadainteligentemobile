import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'logo.dart';


class CustomDrawer {
  late dynamic drawer;
  CustomDrawer(BuildContext context, String actualPage) {
    drawer = Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Logo(size: 100, inverted: true).logoIcon,
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: actualPage == "home" ?
                customCard('Minhas chamadas', context) :
                customCard('Minhas chamadas', context, route: "/home"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: actualPage == "classes" ?
                customCard('Minhas turmas', context) :
                customCard('Minhas turmas', context, route: "/classes"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  AuthUser().logout();
                  if (actualPage == 'home'){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
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
    );
  }

  Widget customCard(String label, BuildContext context, {String? route}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: (){
          if(route == null){
            Navigator.pop(context);
          }
          if (route != null){
            Navigator.popAndPushNamed(context, route);
          }
          if (route == "/home"){
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        child: Card(
          color: Colors.indigo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }
}
