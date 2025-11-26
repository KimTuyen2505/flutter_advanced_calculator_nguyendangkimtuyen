import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _historyKey = 'calc_history';
  static const _settingsKey = 'calc_settings';
  static const _modeKey = 'calc_mode';
  static const _memoryKey = 'calc_memory';
  static const _angleKey = 'calc_angle';

  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> saveHistory(List<Map<String, dynamic>> list) =>
      saveString(_historyKey, jsonEncode(list));

  Future<List<Map<String, dynamic>>> readHistory() async {
    final raw = await readString(_historyKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> saveSettings(Map<String, dynamic> json) =>
      saveString(_settingsKey, jsonEncode(json));

  Future<Map<String, dynamic>?> readSettings() async {
    final raw = await readString(_settingsKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> saveMode(String modeName) => saveString(_modeKey, modeName);

  Future<String?> readMode() => readString(_modeKey);

  Future<void> saveMemory(double value) =>
      saveString(_memoryKey, value.toString());

  Future<double?> readMemory() async {
    final raw = await readString(_memoryKey);
    if (raw == null) return null;
    return double.tryParse(raw);
  }

  Future<void> saveAngle(String angleName) => saveString(_angleKey, angleName);

  Future<String?> readAngle() => readString(_angleKey);
}
