// services/hive_storage.dart
import 'package:hive/hive.dart';

class HiveStorage {
  final String boxName;

  HiveStorage(this.boxName);

  Future<Box> _getBox() async {
    await Hive.openBox(boxName);
    return Hive.box(boxName);
  }

  Future<void> saveData(String key, dynamic data) async {
    final box = await _getBox();
    await box.put(key, data);
  }

  Future<dynamic> getData(String key) async {
    final box = await _getBox();
    return box.get(key);
  }
}
