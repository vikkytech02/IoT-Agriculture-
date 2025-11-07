import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sensor_data.dart';

class FirebaseService {
  final _col = FirebaseFirestore.instance.collection('farm_readings');

  Future<void> push(SensorData d) async {
    await _col.add({
      'temperature': d.temperature,
      'humidity': d.humidity,
      'soil': d.soil,
      'timestamp': d.timestamp.toUtc(),
      'pumpOn': d.pumpOn,
    });
  }
}
