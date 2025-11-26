import 'package:flutter_test/flutter_test.dart';
import 'package:test/providers/calculator_provider.dart';
import 'package:test/utils/expression_parser.dart';
import 'package:test/services/storage_service.dart';
import 'package:test/providers/history_provider.dart';
import 'package:test/models/calculation_history.dart';
import 'package:test/models/calculator_settings.dart';
import 'package:test/utils/calculator_logic.dart';

class MockStorage extends StorageService {
  Map<String, dynamic> store = {};

  @override
  Future<void> saveHistory(List<Map<String, dynamic>> json) async {
    store["history"] = json;
  }
  @override
  Future<List<Map<String, dynamic>>> readHistory() async {
    return (store["history"] ?? []) as List<Map<String, dynamic>>;
  }
  @override
  Future<void> saveMemory(double value) async {
    store["memory"] = value;
  }
  @override
  Future<void> saveMode(String value) async {
    store["mode"] = value;
  }
  @override
  Future<void> saveAngle(String value) async {
    store["angle"] = value;
  }
  @override
  Future<void> saveSettings(Map<String, dynamic> json) async {
    store["settings"] = json;
  }
}
class MockHistory extends HistoryProvider {
  MockHistory(MockStorage storage)
      : super(storage, maxSizeDefault: 50);
}

// UNIT TESTS
void main() {
  late CalculatorProvider calc;
  late MockStorage mockStorage;
  late MockHistory mockHistory;
  setUp(() {
    mockStorage = MockStorage();
    mockHistory = MockHistory(mockStorage);
    calc = CalculatorProvider(
      parser: ExpressionParser(),
      storage: mockStorage,
      historyProvider: mockHistory,
    );
  });

  // Basic operations
  test('Basic: 5 + 3 = 8', () async {
    calc.addToExpression('5+3');
    await calc.calculate();
    expect(calc.result, '8');
  });
   test('Basic: 10 - 4 = 6 ', () async {
    calc.addToExpression('10-4');
    await calc.calculate();
    expect(calc.result, '6');
  });
  test('Order of operations: 2 + 3 × 4 = 14', () async {
    calc.addToExpression('2+3×4');
    await calc.calculate();
    expect(calc.result, '14');
  });
  test('Order of operations: (2 + 3) × 4 = 20', () async {
    calc.addToExpression('(2+3)×4');
    await calc.calculate();
    expect(calc.result, '20');
  });
  test('5 / 0 Infinity', () async {
      calc.clear();
      calc.addToExpression('5÷0');
      await calc.calculate();
      expect(calc.result, 'Infinity');
    });
      test('sqrt(-4) NaN', () async {
    calc.clear();
    calc.addToExpression('sqrt(-4)');
    await calc.calculate();
    expect(calc.result, 'NaN');
  });

  // Scientific functions
  test('Scientific: sin(45°) + cos(45°) ≈ 1.414', () async {
    calc.addToExpression('sin(45)');
    await calc.calculate();
    final s = double.parse(calc.result);
    calc.clear();
    calc.addToExpression('cos(45)');
    await calc.calculate();
    final c = double.parse(calc.result);
    final total = s + c;
    expect(total, closeTo(1.414, 0.01));
  });
  test('sqrt(16) = 4', () async {
      calc.clear();
      calc.addToExpression('sqrt(16)');
      await calc.calculate();
      expect(calc.result, '4');
    });
  test('sin(30) = 0.5', () async {
  calc.clear();
  calc.addToExpression('sin(30)');
  await calc.calculate();
  expect(double.parse(calc.result), closeTo(0.5, 0.01));
});

  // Memory functions
  test('Memory: 5 M+ 3 M+ MR = 8', () async {
  calc.clear();
  calc.addToExpression('5');
  calc.memoryAdd();
  calc.clear();
  calc.addToExpression('3');
  calc.memoryAdd();
  calc.memoryRecall();
  expect(double.parse(calc.result), 8.0);
});

  // chain calculations
  test('Chain: 5+3 = +2 = +1 = 11', () async {
    calc.addToExpression('5+3');
    await calc.calculate();
    calc.addToExpression('+2');
    await calc.calculate();
    calc.addToExpression('+1');
    await calc.calculate();

    expect(calc.result, '11');
  });

  // Parentheses nesting
  test('Parentheses: ((2+3) × (4-1)) ÷ 5 = 3', () async {
    calc.addToExpression('((2+3)×(4-1))÷5');
    await calc.calculate();
    expect(calc.result, '3');
  });

  // mixed scientific 
  test('Mixed scientific: 2 × π × √9 ≈ 18.85', () async {
    calc.addToExpression('2×π×sqrt(9)');
    await calc.calculate();
    final result = double.parse(calc.result);
    expect(result, closeTo(18.85, 0.1));
  });
  
  // programmer 
  test('0x0F OR 0xF0 = 0xFF', () {
  final result = CalculatorLogic.or(0x0F, 0xF0);
  expect(result.toRadixString(16).toUpperCase(), 'FF');
});
test('0xAA XOR 0x55 = 0xFF', () {
  final result = CalculatorLogic.xor(0xAA, 0x55);
  expect(result.toRadixString(16).toUpperCase(), 'FF');
});
test('NOT 0x00 = FFFFFFFF', () {
  final result = CalculatorLogic.not(0x00);
  expect(result.toRadixString(16).toUpperCase(), 'FFFFFFFF');
});
test('0x03 << 1 = 0x06', () {
  final result = CalculatorLogic.shiftLeft(0x03, 1);
  expect(result.toRadixString(16).toUpperCase(), '6');
});
test('0x08 >> 1 = 0x04', () {
  final result = CalculatorLogic.shiftRight(0x08, 1);
  expect(result.toRadixString(16).toUpperCase(), '4');
});
test('HEX FF to DEC 255', () {
  final value = int.parse('FF', radix: 16);
  expect(value, 255);
});
test('HEX A5 to BIN 10100101', () {
  final value = int.parse('A5', radix: 16);
  final bin = value.toRadixString(2).padLeft(8, '0');
  expect(bin, '10100101');
});
test('DEC 64 to HEX 40', () {
  final value = 64;
  final hex = value.toRadixString(16).toUpperCase();
  expect(hex, '40');
});
}