
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:health/forget_pass.dart';
import 'package:health/home_page.dart';
import 'package:health/login_page.dart';
import 'package:health/monitoring_page.dart';
import 'package:health/sregister.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();



  runApp(My_care());
}

class My_care extends StatelessWidget {
  const My_care({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'care',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/passreset': (context) => const ForgetPass(),
        '/home': (context) => const hame_page(),
        '/monitor': (context) =>  HealthMonitor(),
      },
    );
  }
}
