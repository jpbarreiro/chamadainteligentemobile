import 'dart:convert';
import 'package:chamadainteligentemobile/models/attendance_model.dart';
import 'package:chamadainteligentemobile/models/course_model.dart';
import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:chamadainteligentemobile/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/chamadainteligente_api.dart';

class CoursePage extends StatefulWidget {
  final CourseModel courseModel;
  const CoursePage({Key? key, required this.courseModel}) : super(key: key);

  @override
  State<CoursePage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<CoursePage> {


  Future<Map<String, dynamic>> getPresences() async {
    List courseAttendances = [];
    List studentAttendances = [];
    var resCourses = await http.get(
      Uri(
          scheme: ChamadaInteligenteAPI.scheme,
          host: ChamadaInteligenteAPI.host,
          path: '${ChamadaInteligenteAPI.path}/attendance/${widget.courseModel.id}',
          port: ChamadaInteligenteAPI.port
      ),
      headers: {'Content-Type': 'application/json'}
    );

    var resAttendances = await http.get(
      Uri(
          scheme: ChamadaInteligenteAPI.scheme,
          host: ChamadaInteligenteAPI.host,
          path: '${ChamadaInteligenteAPI.path}/student_attendance/${AuthUser().userModel.id}',
          port: ChamadaInteligenteAPI.port
      ),
      headers: {'Content-Type': 'application/json'}
    );


    for (var j in jsonDecode(resCourses.body)){
      courseAttendances.add(j);
    }

    for (var j2 in jsonDecode(resAttendances.body)){
      if (j2["status"] == 'p'){
        studentAttendances.add(j2);
      }
    }

    int aulas = courseAttendances.length;
    int presencas = studentAttendances.length;
    int faltas = courseAttendances.length - presencas;
    int porcentagem = (presencas/aulas*100).round();

    return {"aulas": aulas, "presencas": presencas, "faltas": faltas, "porcentagem": porcentagem};
  }

  Future<List<AttendanceModel>> attendanceList() async {
    List<AttendanceModel> attendanceList = [];
    dynamic res = await http.get(
      Uri(
          scheme: ChamadaInteligenteAPI.scheme,
          host: ChamadaInteligenteAPI.host,
          path: '${ChamadaInteligenteAPI.path}/attendance/${widget.courseModel.id}',
          port: ChamadaInteligenteAPI.port
      ),
      headers: {'Content-Type': 'application/json'}
    );

    for (var j in jsonDecode(res.body)){
      AttendanceModel attendanceModel = AttendanceModel(j);
      await attendanceModel.getSubjectName();
      attendanceList.add(attendanceModel);
    }
    return attendanceList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(widget.courseModel.subjectName!).appBar,
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: getPresences(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              "Aulas: ${snapshot.data!["aulas"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Presenças: ${snapshot.data!["presencas"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Faltas: ${snapshot.data!["faltas"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Porcentagem de presença: ${snapshot.data!["porcentagem"]}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder(
              future: attendanceList(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text('Data: ' + snapshot.data![index].startTime.day.toString()
                                  + "/" + snapshot.data![index].startTime.month.toString()
                                  + "/" + snapshot.data![index].startTime.year.toString(),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Horário: ${snapshot.data![index].startTime.hour}:${snapshot.data![index].startTime.minute}0'),
                                  Text('Sala: ${snapshot.data![index].classroom}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        )
      ),
    );
  }
}
