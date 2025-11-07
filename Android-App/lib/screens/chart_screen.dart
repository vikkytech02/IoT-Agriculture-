import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/sqlite_service.dart';
import '../models/sensor_data.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});
  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final sqlite = SQLiteService();
  List<SensorData> data = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await sqlite.init();
    data = await sqlite.all();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tempPoints = data
        .map(
          (d) => FlSpot(
            d.timestamp.millisecondsSinceEpoch.toDouble(),
            d.temperature,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: tempPoints,
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                dotData: FlDotData(show: false),
              ),
            ],
            titlesData: FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
          ),
        ),
      ),
    );
  }
}
