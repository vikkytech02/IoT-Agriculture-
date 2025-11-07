# 🌿 IoT Agriculture — Smart Monitoring & Control System

## 📖 Overview
This project is a **smart IoT-based monitoring and control system** that combines **Arduino sensors** with a **Flutter mobile application**.  
It enables real-time observation of environmental parameters (temperature, humidity, soil moisture, proximity, intrusion) and **remote pump control** via **Bluetooth** and **Firebase** logging.

The system is built with:
- **Arduino UNO / MEGA** for sensor data acquisition and control  
- **Flutter Android App** for visualization, manual control, and analytics  
- **Firebase / SQLite** for data storage and charts  

---

## 🧠 System Architecture
[Sensors] → [Arduino] → [HC-05 Bluetooth] → [Flutter Mobile App] → [Firebase/SQLite]

---

## ⚙️ Hardware Features (Arduino)
✅ **Temperature & Humidity Monitoring** – via DHT11 sensor  
✅ **Soil Moisture Control** – auto water pump management  
✅ **Proximity Detection** – ultrasonic distance sensing  
✅ **Laser-LDR Intrusion Detection** – beam-break alert system  
✅ **Buzzer Alerts** – different tones based on event type  
✅ **Bluetooth Transmission** – sends sensor data to mobile app  

---

## 📱 Android App (Flutter)
The **IoT Agriculture App** serves as a companion dashboard for the Arduino hardware.

### ✨ Features
- 📊 **Real-time temperature & humidity** display  
- 🌾 **Soil moisture graph** with time-based trend visualization  
- ⚡ **Manual pump control** (ON/OFF)  
- 🔔 **Live pump status** and last active time  
- ☁️ **Firebase Integration** for cloud logging  
- 💾 **SQLite storage** for offline data  
- 🖤 **Soft dark theme** UI for comfortable viewing  

---

## 🎨 App Design
| Screen | Description |
|--------|--------------|
| 🌡️ Dashboard | Displays live temperature, humidity, and pump status |
| 💧 Manual Control | Toggle pump manually |
| 📈 Charts | View soil moisture and environmental trends |
| ⚙️ Settings | Manage Bluetooth & local storage options |

---

## 🧰 Hardware Components
| Component | Pin | Description |
|------------|-----|-------------|
| DHT11 Sensor | A1 | Temperature & Humidity |
| Soil Moisture Sensor | A0 | Detects soil dryness |
| Ultrasonic Sensor | Trig = 3, Echo = 2 | Distance measurement |
| Buzzer | 13 | Audio alert output |
| Laser Module | 22 | Constant beam for LDR detection |
| LDR Sensor | 23 | Detects beam interruption |
| Relay Module | 24 | Controls water pump |
| Bluetooth (HC-05) | TX = 0, RX = 1 | Sends data to app |

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
Data sent by Arduino every loop:
```
<temperature>;<humidity>
```

Example:
```
27.5;62.4
```

---

## ⚙️ Adjustable Parameters
| Variable | Description | Default |
|-----------|--------------|----------|
| `DRY_THRESHOLD` | Moisture value below which pump turns ON | 400 |
| `WET_THRESHOLD` | Moisture value above which pump turns OFF | 600 |
| `LDR_INTERVAL` | Fast beep interval | 100 ms |
| `SONO_INTERVAL` | Slow beep interval | 500 ms |

---

## 📲 Flutter App Setup
### 1️⃣ Install dependencies
```bash
flutter pub get
```

### 2️⃣ Firebase setup (if using Firebase)
```bash
flutterfire configure
```

### 3️⃣ Run the app on a connected device
```bash
flutter run
```

### 4️⃣ Build APK (for sharing)
```bash
flutter build apk --release
```

---

## 🗂️ Folder Structure
```
IoT-Agriculture-/
├── Arduino-Code/
│   └── iot_agriculture.ino
├── Android-App/
│   ├── lib/
│   ├── android/
│   ├── assets/
│   ├── pubspec.yaml
│   └── ...
└── README.md
```

---

## 🧩 Arduino Libraries Required
Install via **Arduino IDE → Sketch → Include Library → Manage Libraries**:
- [DHT sensor library](https://github.com/adafruit/DHT-sensor-library)
- [Adafruit Unified Sensor](https://github.com/adafruit/Adafruit_Sensor)

---

## 💡 Future Improvements
- 🌐 Cloud dashboard for remote monitoring  
- 🕒 Real-time clock (RTC) for timestamped logging  
- 🌦️ IoT cloud sync via MQTT  
- 🧠 AI-based irrigation decision logic  

---

## 🧑‍💻 Author
**Vikky ([@vikkytech02](https://github.com/vikkytech02))**  
🌾 *IoT Agriculture — Smart Monitoring & Control System*  
📅 **Version:** 2.0 (Arduino + Flutter)  
📍 Built with ❤️ using Arduino & Flutter  

---

✨ *Bringing automation and comfort to modern farming — one sensor at a time.* 🌱