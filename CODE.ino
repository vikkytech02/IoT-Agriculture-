#include <DHT.h>
#define DHTPIN A1
#define DHTTYPE DHT11

const int soilMoisturePin = A0;
const int echoPin = 2;
const int trigPin = 3;
const int buzzerPin = 13;
const int laserPin = 22;
const int ldrPin = 23; // Use digital pin for LDR
const int relayPin = 24;

DHT dht(DHTPIN, DHTTYPE);

// Timing variables for buzzer patterns
unsigned long previousMillis = 0;
const int ldrPatternInterval = 200;  // 200ms ON/OFF for LDR
const int sonometerPatternInterval = 500; // 500ms ON/OFF for Sonometer
bool buzzerState = false; // Keeps track of buzzer state
int alertType = 0; // 0 = No alert, 1 = LDR alert, 2 = Sonometer alert

bool isDebugMode = false; // Set to false for Android output, true for IDE debugging

void setup() {
  pinMode(laserPin, OUTPUT);
  digitalWrite(laserPin, HIGH); // Turn laser on

  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // Relay off initially

  pinMode(buzzerPin, OUTPUT);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(ldrPin, INPUT); // Set LDR pin as input

  Serial.begin(9600);
  dht.begin();
}

void loop() {
  // Check for laser interruption using LDR
  int ldrValue = digitalRead(ldrPin); // Read digital state
  if (ldrValue == HIGH) { // Laser interrupted
    alertType = 1; // LDR alert
  } else {
    alertType = 0; // No alert
  }

  // Ultrasonic sensor to measure distance
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000); // 30ms timeout
  int distance = duration * 0.034 / 2;
  if (distance < 30 && distance > 0) { // Check for valid reading
    alertType = 2; // Sonometer alert
  }

  // Soil moisture sensor
  int soilMoistureValue = analogRead(soilMoisturePin);
  if (soilMoistureValue < 500) { // Adjust threshold as per your sensor
    digitalWrite(relayPin, HIGH);
  } else {
    digitalWrite(relayPin, LOW);
  }

  // Read DHT sensor for temperature and humidity
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  if (!isnan(humidity) && !isnan(temperature)) {
    if (isDebugMode) {
      // Detailed output for debugging in IDE terminal
      Serial.print("Temperature: ");
      Serial.print(temperature);
      Serial.print(" °C, Humidity: ");
      Serial.print(humidity);
      Serial.print(" %, Soil Moisture: ");
      Serial.print(soilMoistureValue);
      Serial.print(", Distance: ");
      Serial.print(distance);
      Serial.print(" cm, LDR: ");
      Serial.println(ldrValue == HIGH ? "Laser Broken" : "Clear");
    } else {
      // Minimal output for Android
      Serial.print(temperature);
      Serial.print(";");
      Serial.print(humidity);
      Serial.println(";");
    }
  }

  // Handle buzzer patterns
  handleBuzzer();

  // Delay for soil moisture and DHT updates
  delay(1000);
}

void handleBuzzer() {
  unsigned long currentMillis = millis();
  int interval = 0;

  if (alertType == 1) { // LDR Alert
    interval = ldrPatternInterval;
  } else if (alertType == 2) { // Sonometer Alert
    interval = sonometerPatternInterval;
  } else {
    digitalWrite(buzzerPin, LOW); // Turn buzzer off for no alert
    return;
  }

  // Toggle buzzer state based on the interval
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    buzzerState = !buzzerState;
    digitalWrite(buzzerPin, buzzerState ? HIGH : LOW);
  }
}
