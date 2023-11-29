

import 'dart:convert';

import 'package:chamadainteligentemobile/models/course_model.dart';
import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/attendance_model.dart';
import '../services/chamadainteligente_api.dart';

class TeacherCoursePage extends StatefulWidget {
  final CourseModel courseModel;
  const TeacherCoursePage({Key? key, required this.courseModel}) : super(key: key);

  @override
  State<TeacherCoursePage> createState() => _TeacherCoursePageState();
}

class _TeacherCoursePageState extends State<TeacherCoursePage> {

  getStatistics() async {
    int totalClasses = 0;
    int totalStudents = 0;
    int totalAttendances = 0;
    List attendanceList = [];
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
      totalClasses++;


      List studentList = [];
      final request = http.Request(
        'GET',
        Uri.parse('${ChamadaInteligenteAPI.scheme}://'
            '${ChamadaInteligenteAPI.host}:'
            '${ChamadaInteligenteAPI.port}/'
            '${ChamadaInteligenteAPI.path}/student_courses'),);
      request.headers.addAll({'Content-Type': 'application/json'});
      request.body = jsonEncode({
        "id": attendanceModel.courseId,
      });
      final response = await request.send();
      final responseJson = await response.stream.bytesToString();
      for (var j in jsonDecode(responseJson)){
        totalStudents++;
        studentList.add(j);
      }

      List studentAttendanceList = [];
      final request2 = http.Request(
        'GET',
        Uri.parse('${ChamadaInteligenteAPI.scheme}://'
            '${ChamadaInteligenteAPI.host}:'
            '${ChamadaInteligenteAPI.port}/'
            '${ChamadaInteligenteAPI.path}/student_attendance'),);
      request2.headers.addAll({'Content-Type': 'application/json'});
      request2.body = jsonEncode({
        "id": attendanceModel.id,
      });
      final response2 = await request2.send();
      final response2Json = await response2.stream.bytesToString();
      for (var j2 in jsonDecode(response2Json)){
        totalAttendances++;
        if (j2["status"] == 'p'){
          studentAttendanceList.add(j2);
        }
      }
      attendanceList.add([attendanceModel, studentList.length, studentAttendanceList.length]);
    }
    return {
      "attendances": totalAttendances,
      "classes": totalClasses,
      "students": totalStudents,
      "attendanceList": attendanceList
    };
  }

  @override
  Widget build(BuildContext context) {
    widget.courseModel.getCourseName();
    return Scaffold(
      appBar: CustomAppBar(widget.courseModel.subjectName!).appBar,
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: getStatistics(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasData){
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      children: [
                        Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Aulas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data["classes"].toString()),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text('Alunos Possiveis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data["students"].toString()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Presenças Totais', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(snapshot.data["attendances"].toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data["attendanceList"].length,
                            itemBuilder: (BuildContext context, int index){
                              return Card(
                                child: ListTile(
                                  title: Text(snapshot.data["attendanceList"][index][0].subjectName! + ' - ' + snapshot.data["attendanceList"][index][0].startTime.day.toString() + '/' + snapshot.data["attendanceList"][index][0].startTime.month.toString() + '/' + snapshot.data["attendanceList"][index][0].startTime.year.toString()),
                                  subtitle: Text('Alunos: ${snapshot.data["attendanceList"][index][1]} | Presenças: ${snapshot.data["attendanceList"][index][2]}'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],

        ),
      ),
    );
  }
}
