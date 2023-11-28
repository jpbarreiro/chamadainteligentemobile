import 'dart:convert';

import 'package:chamadainteligentemobile/models/attendance_model.dart';
import 'package:chamadainteligentemobile/models/course_model.dart';
import 'package:chamadainteligentemobile/models/user_model.dart';
import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:chamadainteligentemobile/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


import '../services/chamadainteligente_api.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? choosenDate;
  String? choosenDateInString;

  attendanceList(){
    return FutureBuilder(
      future: AuthUser().userModel.role == 'teacher' ? getTeacherAttendances() : getAttendances(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<AttendanceModel> attendances = snapshot.data;
          print(snapshot.data);
          Widget returnWidget;
          attendances.length != 0 ? returnWidget =
          ListView.builder(
            itemCount: attendances.length,
            itemBuilder: (BuildContext context, int index) {
              return buildAttendanceContainer(
                attendance: attendances[index],
              );
            },
          ) :
          returnWidget = Center(
            child: Text(
              'Seja bem vindo ${AuthUser().userModel.name}\nNenhuma chamada no dia $choosenDateInString',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
          );
          return returnWidget;
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  getTeacherAttendances() async {
    List<AttendanceModel> attendances = [];

    final request = http.Request(
      'GET',
      Uri.parse('${ChamadaInteligenteAPI.scheme}://'
          '${ChamadaInteligenteAPI.host}:'
          '${ChamadaInteligenteAPI.port}/'
          '${ChamadaInteligenteAPI.path}/attendance/${AuthUser().userModel.id}'),);
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body = jsonEncode({
      "teacher_id": AuthUser().userModel.id.toString(),
      "day": DateTime(choosenDate!.year, choosenDate!.month, choosenDate!.day).toString(),
    });
    final response = await request.send();
    final responseJson = await response.stream.bytesToString();

    for (var j in jsonDecode(responseJson)){
      AttendanceModel attendanceModel = AttendanceModel(j);
      await attendanceModel.getSubjectName();
      attendances.add(attendanceModel);
    }
    return attendances;
  }

  getAttendances() async {
    List<AttendanceModel> attendances = [];

    final request = http.Request(
      'GET',
      Uri.parse('${ChamadaInteligenteAPI.scheme}://'
          '${ChamadaInteligenteAPI.host}:'
          '${ChamadaInteligenteAPI.port}/'
          '${ChamadaInteligenteAPI.path}/attendance/${AuthUser().userModel.id}'),);
    request.headers.addAll({'Content-Type': 'application/json'});
    request.body = jsonEncode({
      "day": DateTime(choosenDate!.year, choosenDate!.month, choosenDate!.day).toString(),
    });
    final response = await request.send();
    final responseJson = await response.stream.bytesToString();

    for (var j in jsonDecode(responseJson)){
      AttendanceModel attendanceModel = AttendanceModel(j);
      await attendanceModel.getSubjectName();
      if (DateTime.now().year <= attendanceModel.startTime.year){
        if (DateTime.now().month <= attendanceModel.startTime.month){
          if (DateTime.now().day <= attendanceModel.startTime.day){
            if (DateTime.now().hour < attendanceModel.startTime.hour){
              attendanceModel.status = 'a';
              attendances.add(attendanceModel);
            } else {
              await attendanceModel.setStatus();
              attendances.add(attendanceModel);
            }
          } else {
            await attendanceModel.setStatus();
            attendances.add(attendanceModel);
          }
        } else {
          await attendanceModel.setStatus();
          attendances.add(attendanceModel);
        }
      } else {
        await attendanceModel.setStatus();
        attendances.add(attendanceModel);
      }
      print(attendanceModel.status);
    }
    return attendances;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  createAttendance(
      DateTime startTime,
      DateTime endTime,
      int courseId,
      String classroom,
      double locX,
      double locY
      ) async {
    var res = await http.post(
        Uri(
            scheme: ChamadaInteligenteAPI.scheme,
            host: ChamadaInteligenteAPI.host,
            path: '${ChamadaInteligenteAPI.path}/attendance',
            port: ChamadaInteligenteAPI.port
        ),
        body: jsonEncode({
          "attendance": {
            "start_time": startTime.toString(),
            "end_time": endTime.toString(),
            "course_id": courseId,
            "classroom": classroom,
            "localizationx": locX,
            "localizationy": locY,
          }}),
        headers: {'Content-Type': 'application/json'}
    );


  }





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

  getDistance(double locX, double locY) async {
    Position studentPosition = await determinePosition();
    double distanceInMeters = Geolocator.distanceBetween(studentPosition.latitude, studentPosition.longitude, locX, locY);
    return distanceInMeters;
  }

  confirmAttendance(AttendanceModel attendance){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar presença"),
          content: const Text("Deseja confirmar presença na chamada?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                DateTime today = DateTime.now();
                if (attendance.startTime.day == today.day &&
                    attendance.startTime.month == today.month &&
                    attendance.startTime.year == today.year) {
                  if (attendance.startTime.hour > today.hour){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("A chamada ainda não começou")));
                    Navigator.pop(context);
                    return;
                  } else if (attendance.endTime.hour < today.hour) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("A chamada já acabou")));
                    Navigator.pop(context);
                    return;
                  } else {
                    var teacherDistance = await getDistance(
                        attendance.localizationX, attendance.localizationY);
                    if (teacherDistance <= 7) {
                      http.post(
                          Uri(
                              scheme: ChamadaInteligenteAPI.scheme,
                              host: ChamadaInteligenteAPI.host,
                              path:
                                  '${ChamadaInteligenteAPI.path}/student_attendance',
                              port: ChamadaInteligenteAPI.port),
                          body: jsonEncode({
                            "student_attendance": {
                              "student_id": AuthUser().userModel.id,
                              "attendance_id": attendance.id,
                              "status": "p",
                              "comment": "Presença confirmada",
                            }
                          }),
                          headers: {'Content-Type': 'application/json'});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Presença confirmada com sucesso")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Você está muito longe da sala de aula")));
                    }
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("A chamada não é hoje")));
                  Navigator.pop(context);
                }
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  Widget buildAttendanceContainer({
    required AttendanceModel attendance,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){confirmAttendance(attendance);},
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.indigo),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                attendance.subjectName,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Inicio: ${attendance.startTime.hour}:00',
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                'Fim: ${attendance.endTime.hour}:00',
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                'Sala: ${attendance.classroom}',
                style: const TextStyle(fontSize: 16.0),
              ),
              attendance.status != null ?
              Text(attendance.status == 'p' ? 'Status: Presente' : attendance.status == 'f' ? 'Status: Falta' : 'Status: Ainda não começou',
                style: TextStyle(
                  fontSize: 16.0,
                  color: attendance.status == 'p' ? Colors.green : attendance.status == 'f' ? Colors.red : Colors.grey,
                ),
              ) : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  getTeacherCourses() async {
    List<CourseModel> courseList = [];
    var res = await http.get(
        Uri(
            scheme: ChamadaInteligenteAPI.scheme,
            host: ChamadaInteligenteAPI.host,
            path: '${ChamadaInteligenteAPI.path}/courses/${AuthUser().userModel.id}',
            port: ChamadaInteligenteAPI.port
        ),
        headers: {'Content-Type': 'application/json'}
    );
    for (var j in jsonDecode(res.body)){
      CourseModel course = CourseModel(j);
      await course.getCourseName();
      courseList.add(course);
    }
    return courseList;
  }

  newAttendance(BuildContext context) async {
    late Position teacherPosition;
    teacherPosition = await determinePosition();
    RangeValues manhaRangeValues = RangeValues(7, 9);
    RangeValues noiteRangeValues = RangeValues(14, 16);
    String turno = "manha";
    List<CourseModel> teacherCourses = await getTeacherCourses();
    List<DropdownMenuItem<CourseModel>> dmiCourses = [];
    CourseModel? selectedCourse = teacherCourses[0];
    String? classroom;
    for (CourseModel course in teacherCourses) {
      dmiCourses.add(DropdownMenuItem<CourseModel>(
        value: course,
        child: Text(course.subjectName!, style: TextStyle(color: Colors.indigo), softWrap: true,),
      ));
    }

    if(mounted) {
      return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState){
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Nova chamada',
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<CourseModel>(
                        value: selectedCourse,
                        items: dmiCourses,
                        onChanged: (CourseModel? newValue) {
                          setState(() {
                            selectedCourse = newValue;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Sala de aula', labelStyle: TextStyle(color: Colors.indigo)),
                        onChanged: (value) {
                          classroom = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: turno,
                        items: [
                          DropdownMenuItem(child: Text("Matutino", style: TextStyle(color: Colors.indigo),), value: "manha",),
                          DropdownMenuItem(child: Text("Vespertino/Noturno",style: TextStyle(color: Colors.indigo),), value: "noite",)
                        ], // Create this method
                        onChanged: (String? newValue) {
                          setState(() {
                            turno = newValue!;
                          });
                        },
                      ),
                    ),
                    turno == "manha" ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RangeSlider(
                        activeColor: Colors.indigo,
                        inactiveColor: Colors.grey,
                        values: manhaRangeValues,
                        labels: RangeLabels(
                          manhaRangeValues.start.round().toString(),
                          manhaRangeValues.end.round().toString(),
                        ),
                        min: 7,
                        max: 13,
                        divisions: 3,
                        onChanged: (RangeValues values) {
                          setState(() {
                            manhaRangeValues = values;
                          });
                        },
                      ),
                    ) :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RangeSlider(
                        activeColor: Colors.indigo,
                        inactiveColor: Colors.grey,
                        values: noiteRangeValues,
                        labels: RangeLabels(
                          noiteRangeValues.start.round().toString(),
                          noiteRangeValues.end.round().toString(),
                        ),
                        min: 14,
                        max: 22,
                        divisions: 4,
                        onChanged: (RangeValues values) {
                          setState(() {
                            noiteRangeValues = values;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          teacherPosition = await determinePosition();
                        },
                        icon: Icon(Icons.location_on_outlined, color: Colors.indigo,),
                        label: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Atualizar localização',
                            style: TextStyle(fontSize: 13, color: Colors.indigo),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'X: ${teacherPosition.latitude}',
                            style: TextStyle(color: Colors.indigo),
                          ),
                          Text(
                            'Y: ${teacherPosition.longitude}',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          DateTime startTime = DateTime(
                            choosenDate!.year,
                            choosenDate!.month,
                            choosenDate!.day,
                            turno == "manha" ?
                            manhaRangeValues.start.round() :
                            noiteRangeValues.start.round()
                          );

                          DateTime endTime = DateTime(
                              choosenDate!.year,
                              choosenDate!.month,
                              choosenDate!.day,
                              turno == "manha" ?
                              manhaRangeValues.end.round() :
                              noiteRangeValues.end.round()
                          );
                          createAttendance(
                            startTime,
                            endTime,
                            selectedCourse!.id,
                            classroom!,
                            teacherPosition.latitude,
                            teacherPosition.longitude
                          );
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chamada adicionada com sucesso")));
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.list_alt_sharp, color: Colors.indigo,),
                        label: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Adicionar nova chamada',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.indigo,
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
        }
      );
    }
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
      floatingActionButton: AuthUser().userModel.role == 'teacher' ? FloatingActionButton(
        onPressed: () async {newAttendance(context);},
        child: Icon(Icons.add),
      ): null,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height/20),
                child: customDateButton(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/1.5,
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height/50),
                  child: attendanceList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
