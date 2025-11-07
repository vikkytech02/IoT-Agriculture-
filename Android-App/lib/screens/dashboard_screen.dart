import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BluetoothClassicService bluetoothService = BluetoothClassicService();

  String status = "Disconnected";
  String receivedData = "--";
  bool pumpOn = false;
  bool connecting = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    setState(() {
      connecting = true;
      status = "Connecting...";
    });

    try {
      await bluetoothService.ensureEnabled();
      await bluetoothService.connectToDevice("HC-05");

      setState(() {
        status = "Connected";
        connecting = false;
      });

      // Listen for data from Arduino
      bluetoothService.dataStream.listen((data) {
        setState(() => receivedData = data);
      });
    } catch (e) {
      setState(() {
        status = "Error: $e";
        connecting = false;
      });
    }
  }

  Future<void> _togglePump(bool isOn) async {
    try {
      final command = isOn ? "PUMP_ON" : "PUMP_OFF";
      await bluetoothService.sendData(command);
      setState(() => pumpOn = isOn);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pump turned ${isOn ? 'ON' : 'OFF'}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("⚠️ Error: $e")));
    }
  }

  @override
  void dispose() {
    bluetoothService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          "IoT Agriculture Dashboard",
          style: TextStyle(color: Colors.greenAccent),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: connecting
                  ? const CircularProgressIndicator(color: Colors.greenAccent)
                  : Icon(
                      status == "Connected"
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled,
                      color: status == "Connected"
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      size: 50,
                    ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              "Incoming Data",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                receivedData,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Text(
              "Pump Control",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pumpOn
                        ? Colors.greenAccent
                        : Colors.white10,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    pumpOn ? Icons.water_drop : Icons.water_outlined,
                    color: pumpOn ? Colors.black : Colors.greenAccent,
                  ),
                  label: Text(
                    pumpOn ? "PUMP ON" : "TURN ON",
                    style: TextStyle(
                      color: pumpOn ? Colors.black : Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => _togglePump(!pumpOn),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: Text(
                "Last updated: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.white24, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
