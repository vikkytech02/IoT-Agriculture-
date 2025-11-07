import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sensor_data.dart';

class SQLiteService {
  Database? _db;

  Future<void> init() async {
    final path = join(await getDatabasesPath(), 'iot_agri.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
        CREATE TABLE readings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          temperature REAL,
          humidity REAL,
          soil REAL,
          timestamp TEXT,
          pumpOn INTEGER
        )
        ''');
      },
    );
  }

  Future<void> insert(SensorData d) async => _db?.insert('readings', d.toMap());

  Future<List<SensorData>> all() async {
    final rows = await _db!.query(
      'readings',
      orderBy: 'timestamp DESC',
      limit: 500,
    );
    return rows.map((e) => SensorData.fromMap(e)).toList();
  }
}
