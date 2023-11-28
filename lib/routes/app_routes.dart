import 'package:chamadainteligentemobile/pages/home_page.dart';
import '../pages/course_page.dart';
import '../pages/courses_page.dart';
import '../pages/login_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const login = '/login';
  static const home = '/home';
  static const courses = '/courses';


  static Map<String, Widget Function(BuildContext)> routes = {
    Routes.login: (context) => const LoginPage(),
    Routes.home: (context) => const HomePage(),
    Routes.courses: (context) => const CoursesPage(),
  };
}