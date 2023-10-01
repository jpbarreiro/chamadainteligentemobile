import 'package:flutter/material.dart';

import 'logo.dart';

class CustomAppBar{
  late dynamic appBar;
  CustomAppBar(){
    appBar = AppBar(

      centerTitle: true,
      backgroundColor: Colors.indigo,
      title: Text('Chamadas'),
    );
  }
}