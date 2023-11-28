import 'dart:convert';

import 'package:chamadainteligentemobile/models/course_model.dart';
import 'package:chamadainteligentemobile/models/student_attendance_model.dart';
import 'package:chamadainteligentemobile/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../services/chamadainteligente_api.dart';

class AttendanceModel{
  late int id;
  late int courseId;
  late String classId;
  late String subjectName;
  late DateTime startTime;
  late DateTime endTime;
  late String classroom;
  late double localizationX;
  late double localizationY;
  String? status;

  setStatus() async {
    dynamic resAttendances = await http.get(
        Uri(
            scheme: ChamadaInteligenteAPI.scheme,
            host: ChamadaInteligenteAPI.host,
            path: '${ChamadaInteligenteAPI.path}/student_attendance/${AuthUser().userModel.id}',
            port: ChamadaInteligenteAPI.port
        ),
        headers: {'Content-Type': 'application/json'}
    );

    for (var j in jsonDecode(resAttendances.body)){
      StudentAttendance studentAttendance = StudentAttendance(j);
      if (studentAttendance.attendanceId == id){
        status = studentAttendance.status;
        return;
      }
    }
    StudentAttendance newStudentAttendance = StudentAttendance({"attendance_id": id, "status": 'f', "comment": 'Não justificado'});
    status = 'f';
    newStudentAttendance.setAttendanceStatus();
  }


  getSubjectName() async {
    List coursesList = [];
    late String subjectId;
    var resCourses = await http.get(
      Uri(
          scheme: ChamadaInteligenteAPI.scheme,
          host: ChamadaInteligenteAPI.host,
          path: '${ChamadaInteligenteAPI.path}/courses',
          port: ChamadaInteligenteAPI.port
      ),
    );

    for (var j in jsonDecode(resCourses.body)){
      CourseModel courseModel = CourseModel(j);
      coursesList.add(courseModel);
    }

    for (CourseModel c in coursesList){
      if (c.id == courseId){
        classId = c.courseId;
        subjectId = c.subjectId;
      }
    }

    var res = await http.get(
        Uri(
            scheme: ChamadaInteligenteAPI.scheme,
            host: ChamadaInteligenteAPI.host,
            path: '${ChamadaInteligenteAPI.path}/subjects/$subjectId',
            port: ChamadaInteligenteAPI.port
        ),
        headers: {'Content-Type': 'application/json'},
    );
    subjectName = res.body;
  }


  AttendanceModel(Map<String, dynamic> json){
    id = json["id"];
    courseId = json["course_id"];
    startTime = DateTime.parse(json["start_time"]);
    endTime = DateTime.parse(json["end_time"]);
    classroom = json["classroom"];
    localizationX = json["localizationx"];
    localizationY = json["localizationy"];
  }
}