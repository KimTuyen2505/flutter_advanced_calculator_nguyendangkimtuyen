import 'package:flutter/foundation.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService _storageService;
  final int maxSizeDefault;
  HistoryProvider(this._storageService, {this.maxSizeDefault = 50});

  final List<CalculationHistory> _items = [];
  int _maxSize = 50;

  List<CalculationHistory> get items => List.unmodifiable(_items);
  int get maxSize => _maxSize;

  Future<void> load() async {
    final listJson = await _storageService.readHistory();
    _items
      ..clear()
      ..addAll(listJson.map(CalculationHistory.fromJson));
    notifyListeners();
  }

  Future<void> setMaxSize(int size) async {
    _maxSize = size;
    while (_items.length > _maxSize) {
      _items.removeAt(0);
    }
    await _save();
    notifyListeners();
  }
  Future<void> addEntry(CalculationHistory entry) async {
    _items.add(entry);
    if (_items.length > _maxSize) {
      _items.removeAt(0);
    }
    await _save();
    notifyListeners();
  }

  List<CalculationHistory> last(int n) => _items.reversed.take(n).toList();

  Future<void> clear() async {
    _items.clear();
    await _save();
    notifyListeners();
  }
  Future<void> _save() async {
    await _storageService.saveHistory(_items.map((e) => e.toJson()).toList());
  }
}
