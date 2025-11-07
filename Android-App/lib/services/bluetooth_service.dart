import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothClassicService {
  static final BluetoothClassicService _instance =
      BluetoothClassicService._internal();
  factory BluetoothClassicService() => _instance;

  BluetoothClassicService._internal();

  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  final StreamController<String> _dataController = StreamController.broadcast();

  bool get isConnected => _connection != null && _connection!.isConnected;
  Stream<String> get dataStream => _dataController.stream;

  /// Request runtime permissions for Android 12+
  Future<void> _ensureBluetoothPermissions() async {
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ];

    Map<Permission, PermissionStatus> status = await permissions.request();

    if (status.values.any((s) => s.isDenied)) {
      throw Exception('Bluetooth or Location permission denied');
    }
  }

  /// Ensure Bluetooth is ON
  Future<void> ensureEnabled() async {
    await _ensureBluetoothPermissions();

    final isEnabled = await _bluetooth.isEnabled;
    if (!(isEnabled ?? false)) {
      await _bluetooth.requestEnable();
    }
  }

  /// Connect to device by name (e.g. "HC-05")
  Future<void> connectToDevice(String deviceName) async {
    await ensureEnabled();

    final devices = await _bluetooth.getBondedDevices();
    final target = devices.firstWhere(
      (d) => d.name == deviceName,
      orElse: () => throw Exception('Device $deviceName not paired'),
    );

    _connection = await BluetoothConnection.toAddress(target.address);
    _listenToIncomingData();
    print('✅ Connected to ${target.name}');
  }

  /// Listen to data stream
  void _listenToIncomingData() {
    _connection?.input
        ?.listen((Uint8List data) {
          final incoming = utf8.decode(data);
          _dataController.add(incoming.trim());
        })
        .onDone(() {
          print('🔌 Disconnected');
          _connection = null;
        });
  }

  /// Send command to Arduino
  Future<void> sendData(String command) async {
    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(utf8.encode("$command\n"));
      await _connection!.output.allSent;
    } else {
      throw Exception('Not connected to any Bluetooth device');
    }
  }

  /// Disconnect manually
  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
  }
}
