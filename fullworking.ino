#include <Wire.h>
#include "MAX30100_PulseOximeter.h"
#include <DHT.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// === WiFi ===
#define WIFI_SSID "Notes"
#define WIFI_PASSWORD "Rai@8888"

// === Firebase ===
#define API_KEY "AIzaSyA5UnP8-yvZ5ZU3VmwbzxjpEQL0c3m8N1I"
#define DATABASE_URL "https://healthcare-b176a-default-rtdb.firebaseio.com/"
#define USER_EMAIL "workforcode9@gmail.com"
#define USER_PASSWORD "GauravRai#18"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// === Sensors ===
PulseOximeter pox;
#define DHTPIN 4
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);
const int ky028AnalogPin = 34;
const int numSamples = 10;

uint32_t tsLastReport = 0;
#define REPORT_INTERVAL 2000  // 5 seconds

void onBeatDetected() {
  Serial.println("Beat Detected!");
}

void connectToWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  WiFi.setSleep(false);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(" Connected!");
}

void setup() {
  Serial.begin(115200);
  connectToWiFi();

  // Firebase
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // MAX30100
  Wire.begin(21, 22);
  if (!pox.begin()) {
    Serial.println("MAX30100 init failed. Check wiring.");
    while (1);
  }
  pox.setIRLedCurrent(MAX30100_LED_CURR_27_1MA);
  pox.setOnBeatDetectedCallback(onBeatDetected);

  dht.begin();
  pinMode(ky028AnalogPin, INPUT);
}

float readAverageTemperatureC() {
  long total = 0;
  for (int i = 0; i < numSamples; i++) {
    total += analogRead(ky028AnalogPin);
    delay(5);
  }
  float avgRaw = total / float(numSamples);
  float voltage = avgRaw * (3.3 / 4095.0);
  return voltage * 100.0;
}

void uploadData(String path, String key, float value) {
  if (!Firebase.RTDB.setFloat(&fbdo, path + "/" + key, value)) {
    Serial.print("Firebase setFloat failed for ");
    Serial.print(key);
    Serial.print(": ");
    Serial.println(fbdo.errorReason());
  }
}

void loop() {
  pox.update();

  if (millis() - tsLastReport > REPORT_INTERVAL) {
    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("WiFi disconnected. Reconnecting...");
      connectToWiFi();
    }

    float hr = pox.getHeartRate();
    float spo2 = pox.getSpO2();

    if (hr == 0.0 || spo2 == 0.0) {
      Serial.println("MAX30100 not ready. Skipping upload.");
      tsLastReport = millis();
      return;
    }

    float kyTemp = readAverageTemperatureC();
    float dhtTemp = dht.readTemperature();
    float dhtHum = dht.readHumidity();

    Serial.println("=== Sensor Data ===");
    Serial.print("Heart rate: "); Serial.println(hr);
    Serial.print("SpO2: "); Serial.println(spo2);
    Serial.print("KY Temp: "); Serial.println(kyTemp);
    Serial.print("DHT Temp: "); Serial.println(dhtTemp);
    Serial.print("Humidity: "); Serial.println(dhtHum);

    String path = "/sensor_data";
    uploadData(path, "heart_rate", hr);
    uploadData(path, "spo2", spo2);
    uploadData(path, "ky028_temp", kyTemp);
    uploadData(path, "dht11_temp", dhtTemp);
    uploadData(path, "humidity", dhtHum);

    tsLastReport = millis();
  }
}
