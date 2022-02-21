import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:dedaldev/models/vehicle.dart';

class DatabaseProvider {
  static const dbName = 'garage.db';

  static final DatabaseProvider instance = DatabaseProvider._init();
  DatabaseProvider._init();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDb(dbName);

    return _database;
  }

  _initDb(String dbName) async {
    var appDirectory = await getApplicationDocumentsDirectory();

    String path = join(appDirectory.path, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $vehicleTable (
            ${VehicleField.id} INTEGER PRIMARY KEY,
            ${VehicleField.manufacturer} TEXT, 
            ${VehicleField.model} TEXT, 
            ${VehicleField.description} TEXT,
            ${VehicleField.vehicleType} TEXT,
            ${VehicleField.imagePath} TEXT)''');
      },
    );
  }

  Future<List<Vehicle>> getAllRecords() async {
    final db = await DatabaseProvider.instance.database;

    final records = await db!.query(
      vehicleTable,
      orderBy: '${VehicleField.id} DESC',
    );

    return records.map((e) => Vehicle.fromJson(e)).toList();
  }

  Future<int> insertRecord(Vehicle vehicle) async {
    final db = await DatabaseProvider.instance.database;

    return await db!.insert(
      vehicleTable,
      vehicle.toJson(),
    );
  }

  Future<int> updateRecord(Vehicle vehicle) async {
    final db = await DatabaseProvider.instance.database;

    return await db!.update(
      vehicleTable,
      vehicle.toJson(),
      where: '${VehicleField.id} = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await DatabaseProvider.instance.database;

    return await db!.delete(
      vehicleTable,
      where: '${VehicleField.id} = ?',
      whereArgs: [id],
    );
  }
}

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _items = [];

  List<Vehicle> get items => [..._items];

  Future fetchAndSet() async {
    _items = await DatabaseProvider.instance.getAllRecords();
    notifyListeners();
  }

  Future add(Vehicle vehicle) async {
    _items.insert(0, vehicle);
    notifyListeners();
    await DatabaseProvider.instance.insertRecord(vehicle);
  }

  Future update(Vehicle vehicle) async {
    final index = _items.indexWhere((e) => e.id == vehicle.id);

    if (index != -1) {
      _items[index] = vehicle;
      notifyListeners();
      await DatabaseProvider.instance.updateRecord(vehicle);
    }
  }

  Future delete(int id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    await DatabaseProvider.instance.deleteRecord(id);
  }
}
