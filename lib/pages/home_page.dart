import 'package:chamadainteligentemobile/models/user_model.dart';
import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:chamadainteligentemobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? choosenDate;
  String? choosenDateInString;

  Widget customDateButton(){
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        padding: const EdgeInsets.all(8),
        backgroundColor: Colors.white,
        side: const BorderSide(
          color: Colors.indigo,
          width: 1.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () async {
        final datePick = await showDatePicker(
          context: context,
          locale: const Locale('pt', 'BR'),
          initialDate: choosenDate ?? DateTime.now(),
          firstDate: DateTime.utc(2023),
          lastDate: DateTime(2100),
        );
        if(datePick!=null){
          setState(() {
            choosenDate = datePick;
            choosenDateInString = "${choosenDate!.day}/${choosenDate!.month}/${choosenDate!.year}";
          });
        }
      },
      icon: const Icon(Icons.edit_calendar_outlined, color: Colors.indigo, size: 30,),
      label: Text(
        choosenDateInString!,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.indigo,
            fontSize: 17,
            fontWeight: FontWeight.w400
        ),
      ),
    );
  }

  @override
  void initState() {
    choosenDate = DateTime.now();
    choosenDateInString = "${choosenDate!.day}/${choosenDate!.month}/${choosenDate!.year}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Chamadas').appBar,
      drawer: CustomDrawer(context, "home").drawer,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
              child: customDateButton(),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4),
              child: Text(
                'Seja bem vindo ${AuthUser().userModel.name}',
                //'Nenhuma chamada no dia $choosenDateInString',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
