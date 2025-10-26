#include <DHT.h>

#define DHTPIN A1
#define DHTTYPE DHT11

const int soilMoisturePin = A0;
const int echoPin = 2;
const int trigPin = 3;
const int buzzerPin = 13;
const int laserPin = 22;
const int ldrPin = 23;
const int relayPin = 24;

DHT dht(DHTPIN, DHTTYPE);

// --- Buzzer timing variables ---
unsigned long currentMillis = 0;
unsigned long previousMillis = 0;
unsigned long patternStartMillis = 0;
bool buzzerState = false;

const int LDR_INTERVAL = 100;      // Fast beep for LDR alert
const int SONO_INTERVAL = 500;     // Slow beep for Ultrasonic alert
const int BOTH_BEEP_ON = 100;      // Each beep ON duration
const int BOTH_BEEP_OFF = 100;     // Each beep OFF duration
const int BOTH_PAUSE = 700;        // Pause after triple-beep cycle

int alertType = 0; // 0 = none, 1 = LDR, 2 = Ultrasonic, 3 = Both

// --- Triple beep state ---
int beepCount = 0;
bool inBeepCycle = false;

// Soil-moisture thresholds (tune for your sensor)
const int DRY_THRESHOLD = 400;
const int WET_THRESHOLD = 600;

void setup() {
  pinMode(laserPin, OUTPUT);
  digitalWrite(laserPin, HIGH);  // Laser ON

  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW);   // Relay OFF initially

  pinMode(buzzerPin, OUTPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(ldrPin, INPUT);

  Serial.begin(9600); // Used for Bluetooth (HC-05 on pins 0 & 1)
  dht.begin();
}

void loop() {
  currentMillis = millis();

  // --- LDR beam-break detection ---
  int ldrValue = digitalRead(ldrPin);
  bool ldrAlert = (ldrValue == HIGH); // HIGH means beam broken (adjust if inverted)

  // --- Ultrasonic distance detection ---
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000); // 30 ms timeout
  int distance = duration * 0.034 / 2;
  bool sonoAlert = (distance > 0 && distance < 15); // Object within 15 cm

  // --- Determine alert type ---
  if (ldrAlert && sonoAlert) alertType = 3;
  else if (ldrAlert) alertType = 1;
  else if (sonoAlert) alertType = 2;
  else alertType = 0;

  // --- Soil moisture & relay control ---
  int soilMoisture = analogRead(soilMoisturePin);
  if (soilMoisture < DRY_THRESHOLD) {
    digitalWrite(relayPin, HIGH); // Turn pump ON
  } else if (soilMoisture > WET_THRESHOLD) {
    digitalWrite(relayPin, LOW);  // Turn pump OFF
  }

  // --- DHT readings ---
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  if (!isnan(humidity) && !isnan(temperature)) {
    // Send over Bluetooth (HC-05)
    Serial.print(temperature);
    Serial.print(";");
    Serial.println(humidity);
  }

  // --- Handle buzzer patterns ---
  handleBuzzerPattern();

  delay(100); // Small cooperative delay (non-blocking)
}

// ===================================================
//                Buzzer pattern logic
// ===================================================
void handleBuzzerPattern() {
  switch (alertType) {
    case 0: // No alert
      digitalWrite(buzzerPin, LOW);
      buzzerState = false;
      inBeepCycle = false;
      beepCount = 0;
      break;

    case 1: // LDR only – fast beep
      if (currentMillis - previousMillis >= LDR_INTERVAL) {
        previousMillis = currentMillis;
        buzzerState = !buzzerState;
        digitalWrite(buzzerPin, buzzerState);
      }
      break;

    case 2: // Ultrasonic only – slow beep
      if (currentMillis - previousMillis >= SONO_INTERVAL) {
        previousMillis = currentMillis;
        buzzerState = !buzzerState;
        digitalWrite(buzzerPin, buzzerState);
      }
      break;

    case 3: // Both – triple short beeps then pause
      if (!inBeepCycle) {
        inBeepCycle = true;
        beepCount = 0;
        patternStartMillis = currentMillis;
        digitalWrite(buzzerPin, HIGH);
      } else {
        if (buzzerState && (currentMillis - patternStartMillis >= BOTH_BEEP_ON)) {
          buzzerState = false;
          digitalWrite(buzzerPin, LOW);
          patternStartMillis = currentMillis;
          beepCount++;
        } else if (!buzzerState && beepCount < 3 && (currentMillis - patternStartMillis >= BOTH_BEEP_OFF)) {
          buzzerState = true;
          digitalWrite(buzzerPin, HIGH);
          patternStartMillis = currentMillis;
        } else if (beepCount >= 3 && (currentMillis - patternStartMillis >= BOTH_PAUSE)) {
          inBeepCycle = false;
          buzzerState = false;
          digitalWrite(buzzerPin, LOW);
        }
      }
      break;
  }
}
