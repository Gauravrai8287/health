# health-monitoring-system

A real-time health monitoring system built using the ESP32 microcontroller and sensors including MAX30102, KY-028, and DHT11. The system measures heart rate, SpO₂, body temperature, and environmental conditions, sending the data to Firebase and displaying it on a custom-built Flutter mobile app.

📦 Components Used
Component	Description
ESP32	Microcontroller with Wi-Fi capability
MAX30102	Pulse oximeter and heart rate sensor
KY-028	Analog temperature sensor
DHT11	Digital temperature and humidity sensor
Firebase	Cloud platform for real-time data storage
Flutter	Mobile app development framework

⚙️ Features
 Heart rate and SpO₂ measurement using MAX30102
 Body temperature detection with KY-028
 Room temperature & humidity monitoring using DHT11
 Real-time data upload to Firebase Realtime Database or Firestore
 Flutter app to view health metrics remotely
 Can be extended with alerts for abnormal values

🖧 Circuit Connections
Sensor Pin	ESP32 Pin
MAX30102 SDA	GPIO 21
MAX30102 SCL	GPIO 22
KY-028 Analog Out	GPIO 34
DHT11 Data	GPIO 4
Power (All)	3.3V/GND
 Ensure correct voltage level (3.3V) for all components. Use level shifter if necessary.

📲 Firebase Setup
Go to Firebase Console
Create a new project
Enable Realtime Database or Firestore
Add a Web App or get ESP32 credentials (API Key, Database URL, etc.)

Enable anonymous authentication if needed
 Install Required Arduino Libraries
Adafruit MAX30105
Adafruit Unified Sensor
DHT sensor library
Firebase ESP32


3. Configure Arduino Code
Open the code in Arduino IDE and enter your:
Wi-Fi SSID & password
Firebase host & secret/API key

 Upload to ESP32
Select Board: ESP32 Dev Module
Select Port
Upload the sketch

📱 Flutter App
Features:
Live dashboard for heart rate, SpO₂, temperature, and humidity

Auto-refresh from Firebase
Responsive design
Setup:
Install Flutter SDK: flutter.dev

Clone the app code from the /flutter_app folder

Set up Firebase for Flutter:
Download google-services.json from Firebase Console
Place it in android/app/
run the app:

bash

Copy
Edit
Heart Rate: 76 BPM
SpO₂: 98%
Body Temp: 36.4°C
Room Temp: 27.8°C
Humidity: 60%
Firebase JSON (Realtime DB)
json
Copy
Edit
{
  "heartRate": 76,
  "spo2": 98,
  "bodyTemp": 36.4,
  "roomTemp": 27.8,
  "humidity": 60
}
🚀 Future Improvements
⚠️ Abnormal value alerts (SMS or push notification)

📊 Data logging and visualization

👥 Multi-user support in app



