import 'package:flutter/foundation.dart';
import '../models/calculator_mode.dart';
import '../models/calculation_history.dart';
import '../models/calculator_settings.dart';
import '../utils/expression_parser.dart';
import '../utils/calculator_logic.dart';
import '../services/storage_service.dart';
import 'history_provider.dart';

class CalculatorProvider extends ChangeNotifier {
  String _expression = '';
  String _result = '0';
  String? _error;

  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;

  double _memory = 0;
  bool _hasMemory = false;

  final ExpressionParser _parser;
  final StorageService _storage;
  final HistoryProvider _historyProvider;

  CalculatorSettings _settings;

  ProgrammerBase _programmerBase = ProgrammerBase.dec;
  String _programmerDisplay = '0';
  int? _progFirstOperand;
  String? _progPendingOp;

  CalculatorProvider({
    required ExpressionParser parser,
    required StorageService storage,
    required HistoryProvider historyProvider,
    CalculatorSettings? initialSettings,
  })  : _parser = parser,
        _storage = storage,
        _historyProvider = historyProvider,
        _settings = initialSettings ?? const CalculatorSettings();

  String get expression => _expression;
  String get result => _result;
  String? get error => _error;

  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  bool get hasMemory => _hasMemory;

  CalculatorSettings get settings => _settings;

  ProgrammerBase get programmerBase => _programmerBase;
  String get programmerDisplay => _programmerDisplay;

  void setMode(CalculatorMode mode) {
    _mode = mode;
    _storage.saveMode(mode.name);
    notifyListeners();
  }

  /// Change angle mode (DEG/RAD)
  void setAngleMode(AngleMode mode) {
    _angleMode = mode;
    _storage.saveAngle(mode.name);
    notifyListeners();
  }

  void addToExpression(String value) {
    _error = null;
    _expression += value;
    notifyListeners();
  }

  void clear() {
    _expression = '';
    _result = '0';
    _error = null;
    notifyListeners();
  }

  /// Remove last character
  void clearEntry() {
    if (_expression.isEmpty) return;
    _expression = _expression.substring(0, _expression.length - 1);
    _error = null;
    notifyListeners();
  }

  void deleteLast() => clearEntry();

  /// Evaluate mathematical expression
  Future<void> calculate() async {
    _error = null;

    if (_expression.trim().isEmpty) {
      _result = '0';
      notifyListeners();
      return;
    }

    try {
      final value = _parser.evaluate(_expression, angleMode: _angleMode);

      var formatted = value.toStringAsFixed(_settings.decimalPrecision)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');

      _result = formatted;

      // Save to history
      await _historyProvider.addEntry(
        CalculationHistory(
          expression: _expression,
          result: _result,
          timestamp: DateTime.now(),
        ),
      );

      notifyListeners();
    } on FormatException catch (e) {
      _error = e.message;
      notifyListeners();
    } catch (_) {
      _error = 'Error';
      notifyListeners();
    }
  }

  void toggleSign() {
    if (_expression.isEmpty) return;
    _expression =
        _expression.startsWith('-') ? _expression.substring(1) : '-$_expression';
    notifyListeners();
  }

  void addPercentage() {
    if (_expression.isEmpty) return;
    _expression = '($_expression) / 100';
    notifyListeners();
  }
  /// Insert scientific operator
  void addScientificFunction(String func) {
    switch (func) {
      case 'sin':
      case 'cos':
      case 'tan':
      case 'ln':
      case 'log':
        _expression += '$func(';
        break;
      case 'x²':
        _expression = '($_expression)^2';
        break;
      case 'x³':
        _expression = '($_expression)^3';
        break;
      case '√':
        _expression = 'sqrt($_expression)';
        break;
      case '∛':
        _expression = '($_expression)^(1/3)';
        break;
      case 'n!':
        final n = int.tryParse(_expression);
        if (n != null) {
          _expression = CalculatorLogic.factorial(n).toString();
        }
        break;
      case 'π':
        _expression += 'π';
        break;
      case 'e':
        _expression += 'e';
        break;
    }
    notifyListeners();
  }
  /// Current numeric value (for memory ops)
  double _currentNumericValue() {
    final src = _expression.isNotEmpty ? _expression : _result;
    return double.tryParse(src) ?? 0;
  }
  /// M+ Add to memory
  void memoryAdd() {
    _memory += _currentNumericValue();
    _hasMemory = true;
    _storage.saveMemory(_memory);
    notifyListeners();
  }
  void memorySubtract() {
    _memory -= _currentNumericValue();
    _hasMemory = true;
    _storage.saveMemory(_memory);
    notifyListeners();
  }

  void memoryRecall() {
    _expression = _memory.toString();
    _result = _memory.toString();
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0;
    _hasMemory = false;
    _storage.saveMemory(0);
    notifyListeners();
  }
  /// Save settings + apply history size limit
  Future<void> updateSettings(CalculatorSettings newSettings) async {
    _settings = newSettings;
    await _storage.saveSettings(_settings.toJson());
    await _historyProvider.setMaxSize(_settings.historySize);
    notifyListeners();
  }
  /// Convert programmer base enum → radix number
  int _baseToRadix(ProgrammerBase base) {
    switch (base) {
      case ProgrammerBase.bin:
        return 2;
      case ProgrammerBase.oct:
        return 8;
      case ProgrammerBase.dec:
        return 10;
      case ProgrammerBase.hex:
        return 16;
    }
  }

  /// Parse current programmer display
  int _parseProgrammerValue() {
    final text = _programmerDisplay.trim();
    if (text.isEmpty) return 0;
    return int.parse(text, radix: _baseToRadix(_programmerBase));
  }

  /// Update programmer display with new value
  void _setProgrammerValue(int value) {
    final radix = _baseToRadix(_programmerBase);
    _programmerDisplay = value.toRadixString(radix).toUpperCase();
  }

  /// Switch programmer base (HEX/DEC/BIN/OCT)
  void setProgrammerBase(ProgrammerBase base) {
    if (_programmerBase == base) return;
    final currentValue = _parseProgrammerValue();
    _programmerBase = base;
    _setProgrammerValue(currentValue);
    notifyListeners();
  }

  /// Add digit/char for programmer input
  void programmerInput(String char) {
    final upper = char.toUpperCase();

    RegExp allowed;
    switch (_programmerBase) {
      case ProgrammerBase.bin:
        allowed = RegExp(r'^[01]$');
        break;
      case ProgrammerBase.oct:
        allowed = RegExp(r'^[0-7]$');
        break;
      case ProgrammerBase.dec:
        allowed = RegExp(r'^[0-9]$');
        break;
      case ProgrammerBase.hex:
        allowed = RegExp(r'^[0-9A-F]$');
        break;
    }

    if (!allowed.hasMatch(upper)) return;

    _programmerDisplay =
        _programmerDisplay == '0' ? upper : _programmerDisplay + upper;

    notifyListeners();
  }

  /// Delete last digit (Programmer)
  void programmerBackspace() {
    if (_programmerDisplay.length <= 1) {
      _programmerDisplay = '0';
    } else {
      _programmerDisplay =
          _programmerDisplay.substring(0, _programmerDisplay.length - 1);
    }
    notifyListeners();
  }

  /// Clear programmer input
  void programmerClear() {
    _programmerDisplay = '0';
    _progFirstOperand = null;
    _progPendingOp = null;
    notifyListeners();
  }

  /// Handle unary programmer ops (NOT, <<, >>)
  void programmerUnary(String op) {
    var value = _parseProgrammerValue();

    switch (op) {
      case 'NOT':
        value = CalculatorLogic.not(value);
        break;
      case '<<':
        value = CalculatorLogic.shl(value, 1);
        break;
      case '>>':
        value = CalculatorLogic.shr(value, 1);
        break;
    }

    _setProgrammerValue(value);
    notifyListeners();
  }

  /// Store first operand for AND/OR/XOR
  void programmerBinaryOp(String op) {
    _progFirstOperand = _parseProgrammerValue();
    _progPendingOp = op;
    _programmerDisplay = '0';
    notifyListeners();
  }

  /// Execute AND/OR/XOR
  void programmerEquals() {
    if (_progFirstOperand == null || _progPendingOp == null) return;

    final a = _progFirstOperand!;
    final b = _parseProgrammerValue();

    int result;
    switch (_progPendingOp) {
      case 'AND':
        result = CalculatorLogic.and(a, b);
        break;
      case 'OR':
        result = CalculatorLogic.or(a, b);
        break;
      case 'XOR':
        result = CalculatorLogic.xor(a, b);
        break;
      default:
        return;
    }

    _progFirstOperand = null;
    _progPendingOp = null;
    _setProgrammerValue(result);
    notifyListeners();
  }
}
