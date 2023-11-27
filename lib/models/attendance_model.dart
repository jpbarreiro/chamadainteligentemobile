import 'dart:convert';

import 'package:chamadainteligentemobile/models/course_model.dart';
import 'package:http/http.dart' as http;

import '../services/chamadainteligente_api.dart';

class AttendanceModel{
  late int id;
  late int courseId;
  late String subjectName;
  late DateTime startTime;
  late DateTime endTime;
  late String classroom;
  late double localizationX;
  late double localizationY;


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