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
  double mainTemperature = 0.0;
  double heartRate = 0.0;
  double spO2 = 0.0;

  @override
  void initState() {
    super.initState();
    initializeFirebaseListeners();
  }

  Future<void> initializeFirebaseListeners() async {
    try {
      await Firebase.initializeApp();

      dbRef.child("sensor_data/dht11_temp").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            dhtTemperature = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("sensor_data/humidity").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            humidity = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("sensor_data/ky028_temp").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            kyTemperature = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("sensor_data/temperature").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            mainTemperature = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("sensor_data/heart_rate").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            heartRate = double.tryParse(val.toString()) ?? 0.0;
          });
        }
      });

      dbRef.child("sensor_data/spo2").onValue.listen((event) {
        final val = event.snapshot.value;
        if (val != null) {
          setState(() {
            spO2 = double.tryParse(val.toString()) ?? 0;
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
        title: const Text("Health Monitor"),
        centerTitle: true,
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
              buildDataCard("Room Temperature : ${dhtTemperature.toStringAsFixed(2)} °C"),
              const SizedBox(height: 20),
              buildDataCard("Humidity: ${humidity.toStringAsFixed(2)}%"),
              const SizedBox(height: 20),
              buildDataCard("Body Temprature: ${kyTemperature.toStringAsFixed(2)} °C"),
              const SizedBox(height: 20),
      //        buildDataCard("Main Temperature: ${mainTemperature.toStringAsFixed(2)} °C"),
              const SizedBox(height: 20),
              buildDataCard("Heart Rate: $heartRate bpm"),
              const SizedBox(height: 20),
              buildDataCard("SpO2: $spO2%"),
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
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 217, 217, 1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}
