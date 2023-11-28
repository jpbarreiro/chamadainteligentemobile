import 'dart:convert';

import 'package:chamadainteligentemobile/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../services/chamadainteligente_api.dart';

class StudentAttendance{
  late int attendanceId;
  late String comment;
  late String status;
  late String studentId;

  setAttendanceStatus() async {
    var res = await http.post(
      Uri(
          scheme: ChamadaInteligenteAPI.scheme,
          host: ChamadaInteligenteAPI.host,
          path: '${ChamadaInteligenteAPI.path}/student_attendance',
          port: ChamadaInteligenteAPI.port
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "student_attendance": {"attendance_id": attendanceId, "status": status, "comment": comment, "student_id": AuthUser().userModel.id}
        })
    );
  }

  updateAttendanceStatus() async {
    var res = await http.put(
        Uri(
            scheme: ChamadaInteligenteAPI.scheme,
            host: ChamadaInteligenteAPI.host,
            path: '${ChamadaInteligenteAPI.path}/student_attendance/$attendanceId',
            port: ChamadaInteligenteAPI.port
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "student_attendance": {"attendance_id": attendanceId, "status": status, "comment": comment, "student_id": AuthUser().userModel.id}
        })
    );

  }


  StudentAttendance(Map<String, dynamic> json){
    attendanceId = json["attendance_id"];
    comment = json["comment"];
    status = json["status"];
    studentId = json["student_id"];
  }

}