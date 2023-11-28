import 'dart:convert';
import 'package:chamadainteligentemobile/models/user_model.dart';
import 'package:chamadainteligentemobile/models/course_model.dart';
import 'package:chamadainteligentemobile/widgets/custom_app_bar.dart';
import 'package:chamadainteligentemobile/widgets/custom_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../services/chamadainteligente_api.dart';
import 'course_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursesPage> {

  Future<List<List>> getTurmas() async {
    List<List<dynamic>> courseList = [];
    var res = await http.get(
      Uri(
          scheme: ChamadaInteligenteAPI.scheme,
          host: ChamadaInteligenteAPI.host,
          path: '${ChamadaInteligenteAPI.path}/student_courses/${AuthUser().userModel.id}',
          port: ChamadaInteligenteAPI.port
      ),
    );

    for (var turma in jsonDecode(res.body)) {
      CourseModel course = CourseModel(turma);
      String teacherName = await course.getTeacherName();
      await course.getCourseName();
      courseList.add([course, teacherName]);
    }
    return courseList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Turmas').appBar,
      drawer: CustomDrawer(context, "courses").drawer,
      body: Center(
        child: Column(
         children: [
           FutureBuilder(
              future: AuthUser().userModel.role == 'student' ? getTurmas() : null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
                              title: Text(snapshot.data![index][0].subjectName!),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data![index][0].semester),
                                  Text(snapshot.data![index][1]),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CoursePage(courseModel: snapshot.data![index][0],)),
                                );
                              },
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
        ),
      ),
    );
  }
}
