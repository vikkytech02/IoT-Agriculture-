import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Requires google-services.json
  runApp(const IoTAgricultureApp());
}

class IoTAgricultureApp extends StatelessWidget {
  const IoTAgricultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00C853);
    return MaterialApp(
      title: 'IoT-Agriculture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: green,
          secondary: green,
          surface: const Color(0xFF1E1E1E),
          onPrimary: Colors.white,
          onSurface: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
