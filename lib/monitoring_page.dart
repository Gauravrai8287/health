import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart'; // Ensure it's named correctly

class HealthMonitor extends StatefulWidget {
  @override
  _HealthMonitorState createState() => _HealthMonitorState();
}

class _HealthMonitorState extends State<HealthMonitor> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  double temperature = 0.0;
  int heartRate = 0;
  double spo2 = 0.0;

  @override
  void initState() {
    super.initState();
    initializeFirebaseListeners();
  }

  Future<void> initializeFirebaseListeners() async {
    try {
      await Firebase.initializeApp(); // Ensure Firebase is initialized

      dbRef.child("temperature").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            temperature = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("heartrate").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            heartRate = int.tryParse(val.toString()) ?? 0;
          });
        }
      });

      dbRef.child("spo2").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            spo2 = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(79, 137, 113, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(217, 217, 217, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const hame_page()), // Check spelling
            );
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Monitoring',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              buildDataCard("Temperature: ${temperature.toStringAsFixed(2)} °C"),
              const SizedBox(height: 20),
              buildDataCard("Heart Rate: $heartRate BPM"),
              const SizedBox(height: 20),
              buildDataCard("SpO2: ${spo2.toStringAsFixed(1)}%"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDataCard(String text) {
    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      color: const Color.fromRGBO(217, 217, 217, 1),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
