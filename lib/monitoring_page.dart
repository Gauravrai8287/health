import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';

class HealthMonitor extends StatefulWidget {
  @override
  _HealthMonitorState createState() => _HealthMonitorState();
}

class _HealthMonitorState extends State<HealthMonitor> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  double dhtTemperature = 0.0;
  double humidity = 0.0;
  double kyTemperature = 0.0;
  int heartRaw = 0;

  @override
  void initState() {
    super.initState();
    initializeFirebaseListeners();
  }

  Future<void> initializeFirebaseListeners() async {
    try {
      await Firebase.initializeApp();

      dbRef.child("dht11/temperature").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            dhtTemperature = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("dht11/humidity").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            humidity = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("ky028/temperature").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            kyTemperature = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("hw827/heart_raw").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            heartRaw = int.tryParse(val.toString()) ?? 0;
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
              MaterialPageRoute(builder: (context) => const hame_page()),
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
              buildDataCard("Room Temperature: ${dhtTemperature.toStringAsFixed(2)} °C"),
              const SizedBox(height: 20),
              buildDataCard("Room Humidity: ${humidity.toStringAsFixed(2)}%"),
              const SizedBox(height: 20),
              buildDataCard("Body Temperature: ${kyTemperature.toStringAsFixed(2)} °C"),
              const SizedBox(height: 20),
              buildDataCard("Heart Rate: $heartRaw"),
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
        textAlign: TextAlign.center,
      ),
    );
  }
}
