import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:chamadainteligentemobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Turmas').appBar,
      drawer: CustomDrawer(context, "classes").drawer,
      body: Center(),
    );
  }
}
