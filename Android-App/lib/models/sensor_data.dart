class SensorData {
  final double temperature;
  final double humidity;
  final double? soil;
  final DateTime timestamp;
  final bool pumpOn;

  SensorData({
    required this.temperature,
    required this.humidity,
    this.soil,
    required this.timestamp,
    required this.pumpOn,
  });

  Map<String, dynamic> toMap() => {
    'temperature': temperature,
    'humidity': humidity,
    'soil': soil,
    'timestamp': timestamp.toIso8601String(),
    'pumpOn': pumpOn ? 1 : 0,
  };

  factory SensorData.fromMap(Map<String, dynamic> m) => SensorData(
    temperature: (m['temperature'] as num).toDouble(),
    humidity: (m['humidity'] as num).toDouble(),
    soil: m['soil'] != null ? (m['soil'] as num).toDouble() : null,
    timestamp: DateTime.parse(m['timestamp']),
    pumpOn: (m['pumpOn'] ?? 0) == 1,
  );
}
