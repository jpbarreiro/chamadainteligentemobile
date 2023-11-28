import 'dart:convert';

import 'package:chamadainteligentemobile/models/attendance_model.dart';
import 'package:chamadainteligentemobile/models/student_attendance_model.dart';
import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../services/chamadainteligente_api.dart';

class AttendancePage extends StatefulWidget {
  final AttendanceModel attendance;
  const AttendancePage({Key? key, required this.attendance}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {

  Future<List> getStudentList() async {
    List studentList = [];
    final request = http.Request(
      'GET',
      Uri.parse('${ChamadaInteligenteAPI.scheme}://'
          '${ChamadaInteligenteAPI.host}:'
          '${ChamadaInteligenteAPI.port}/'
          '${ChamadaInteligenteAPI.path}/student_courses'),);
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body = jsonEncode({
      "id": widget.attendance.courseId,
    });
    final response = await request.send();
    final responseJson = await response.stream.bytesToString();

    for (var j in jsonDecode(responseJson)){
      studentList.add(j);
    }

    return studentList;
  }

  Future getAttendancePresences()async{
    List<StudentAttendance> attendances = [];
    final request = http.Request(
      'GET',
      Uri.parse('${ChamadaInteligenteAPI.scheme}://'
          '${ChamadaInteligenteAPI.host}:'
          '${ChamadaInteligenteAPI.port}/'
          '${ChamadaInteligenteAPI.path}/student_attendance'),);
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body = jsonEncode({
      "id": widget.attendance.id,
    });
    final response = await request.send();
    final responseJson = await response.stream.bytesToString();

    for (var j in jsonDecode(responseJson)){
      StudentAttendance attendanceModel = StudentAttendance(j);
      if (attendanceModel.status == 'p'){
        attendances.add(attendanceModel);
      }
    }
    print(attendances);
    return attendances;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Chamada do dia ${widget.attendance.startTime.day}/${widget.attendance.startTime.month}/${widget.attendance.startTime.year}'
      ).appBar,
      body: Center(
        child: FutureBuilder<List>(
          future: getStudentList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(snapshot.data![index]["name"]),
                        subtitle: FutureBuilder(
                          future: getAttendancePresences(),
                          builder: (context, snapshot2) {
                            if (snapshot2.hasData) {
                              for (var j2 in snapshot2.data!){
                                if (j2.studentId == snapshot.data![index]["id"]){
                                  return Text(
                                      "Presente",
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                  );
                                }
                              }
                              return Text(
                                  "Ausente",
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
