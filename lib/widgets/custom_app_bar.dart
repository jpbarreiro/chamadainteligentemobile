import 'package:flutter/material.dart';

//import 'logo.dart';

class CustomAppBar {
  late dynamic appBar;
  CustomAppBar(String title) {
    appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.indigo,
      title: Text(title),
    );
  }
}
