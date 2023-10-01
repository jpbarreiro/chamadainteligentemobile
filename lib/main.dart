import 'package:chamadainteligentemobile/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() async {
  ThemeData themeData() {
    return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo)),
      ),
    );
  }

  runApp(
    MaterialApp(
      theme: themeData(),
      title: 'Chamada Inteligente',
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.login,
    )
  );
}
