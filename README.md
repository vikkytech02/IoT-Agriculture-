# 🌿 Smart Monitoring & Alert System (Arduino)

## 📖 Overview
This project is a **multi-sensor smart monitoring and alert system** using an Arduino board.  
It integrates **temperature, humidity, soil moisture, ultrasonic distance, and LDR beam-break sensors**, along with **a buzzer, laser module, and relay-controlled water pump**.

The system:
- Monitors **environmental data** (temperature, humidity, soil moisture).  
- Triggers **audio alerts** (buzzer) based on security or proximity conditions.  
- Controls a **water pump** automatically based on soil moisture level.  
- Sends sensor data over **Bluetooth (HC-05)** for remote monitoring.

---

## ⚙️ Features
✅ **Temperature & Humidity Monitoring** – via DHT11 sensor  
✅ **Soil Moisture Control** – automatic pump activation  
✅ **Proximity Alert** – ultrasonic sensor detects nearby objects  
✅ **Beam-Break Alert** – LDR + laser detects intrusion  
✅ **Buzzer Patterns** – unique alert tones based on event type  
✅ **Bluetooth Data Transmission** – real-time readings to mobile app or PC  

---

## 🧰 Hardware Components
| Component | Pin | Description |
|------------|-----|-------------|
| DHT11 Sensor | A1 | Temperature & Humidity |
| Soil Moisture Sensor | A0 | Detects soil dryness |
| Ultrasonic Sensor (HC-SR04) | Trig = 3, Echo = 2 | Measures distance |
| Buzzer | 13 | Audio alerts |
| Laser Module | 22 | Constant laser beam for LDR |
| LDR Sensor | 23 | Detects laser interruption |
| Relay Module | 24 | Controls water pump |
| Bluetooth Module (HC-05) | TX = 0, RX = 1 | Sends sensor data |
| Arduino UNO / MEGA | — | Main controller |

---

## 🔌 Circuit Description
- The **laser** emits a constant beam towards the **LDR**.  
  If the beam is broken → LDR signal changes → triggers **fast buzzer alert**.  
- The **ultrasonic sensor** detects proximity.  
  If an object is within 15 cm → triggers **slow buzzer alert**.  
- If **both sensors** detect alerts simultaneously → triggers **triple-beep pattern**.  
- The **soil moisture sensor** checks soil dryness:  
  - Below `DRY_THRESHOLD (400)` → Pump **ON**.  
  - Above `WET_THRESHOLD (600)` → Pump **OFF**.  
- The **DHT11** sensor continuously measures temperature & humidity and transmits data via Bluetooth as `temperature;humidity`.

---

## 🔊 Buzzer Alert Patterns
| Condition | Pattern | Description |
|------------|----------|-------------|
| LDR Alert | Fast beeps | Beam broken |
| Ultrasonic Alert | Slow beeps | Object nearby |
| Both Alerts | Triple short beeps + pause | Both triggered |
| No Alert | Silent | Normal operation |

---

## 📡 Bluetooth Output Format
Data sent to HC-05 every loop:  
```
<temperature>;<humidity>
```

Example:
```
27.5;62.4
```
This can be read using a Bluetooth serial app on your phone or PC.

---

## 🧠 Code Logic Summary
1. **Sensor Readings:**  
   - DHT11 → temperature, humidity  
   - LDR → beam detection  
   - Ultrasonic → distance  
   - Soil Moisture → analog value  

2. **Alert Determination:**  
   - Checks LDR + Ultrasonic  
   - Decides alert type (`1 = LDR`, `2 = Ultrasonic`, `3 = Both`)  

3. **Buzzer Pattern Handling:**  
   - Uses non-blocking timing (`millis()`)  
   - Unique sound patterns for each alert type  

4. **Relay Control:**  
   - Turns pump ON/OFF automatically based on soil moisture  

5. **Bluetooth Transmission:**  
   - Sends temperature & humidity readings every loop iteration  

---

## ⚙️ Adjustable Parameters
| Variable | Description | Default |
|-----------|--------------|----------|
| `DRY_THRESHOLD` | Moisture value below which pump turns ON | 400 |
| `WET_THRESHOLD` | Moisture value above which pump turns OFF | 600 |
| `LDR_INTERVAL` | Fast beep interval for LDR alert | 100 ms |
| `SONO_INTERVAL` | Slow beep interval for Ultrasonic alert | 500 ms |
| `BOTH_BEEP_ON` | ON duration for triple beep | 100 ms |
| `BOTH_BEEP_OFF` | OFF duration between triple beeps | 100 ms |
| `BOTH_PAUSE` | Pause after 3 beeps | 700 ms |

---

## 🧩 Dependencies
Install the following libraries using **Arduino IDE → Sketch → Include Library → Manage Libraries**:

- [DHT sensor library](https://github.com/adafruit/DHT-sensor-library)
- [Adafruit Unified Sensor library](https://github.com/adafruit/Adafruit_Sensor)

---

## 📈 Example Serial Output
```
Temperature: 27.50 °C
Humidity: 61.00 %
Soil Moisture: 512
Distance: 10 cm
Alert Type: LDR Only
```

---

## 💡 Possible Enhancements
- Add **LCD or OLED** display for local readings  
- Send data to **IoT platform (ThingSpeak, Blynk, etc.)**  
- Add **real-time clock (RTC)** for time-stamped logging  
- Use **capacitive soil sensor** for higher accuracy  

---

## 🧑‍💻 Author
**Vikky (vikkytech02)**  
Arduino Project – Smart Monitoring & Alert System  
📅 Version: 1.0  
🔗 GitHub: [https://github.com/vikkytech02/IoT-Agriculture-](https://github.com/vikkytech02/IoT-Agriculture-)
