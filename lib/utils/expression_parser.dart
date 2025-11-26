import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';
import '../models/calculator_mode.dart';

class ExpressionParser {
  final Parser _parser = Parser();
  final ContextModel _context = ContextModel();

  ExpressionParser() {
    final piNumber = Number(math.pi);
    final eNumber = Number(math.e);

    _context
      ..bindVariableName('π', piNumber)
      ..bindVariableName('pi', piNumber)
      ..bindVariableName('e', eNumber);
  }
  double evaluate(
    String rawExpression, {
    AngleMode angleMode = AngleMode.degrees,
  }) {
    if (rawExpression.trim().isEmpty) return 0;

    var expression = rawExpression
        .replaceAll('÷', '/')
        .replaceAll('×', '*')
        .replaceAll('−', '-');
    // implicit multiplication: 2π -> 2*π
    expression = expression.replaceAllMapped(
      RegExp(r'(\d)(π|pi|e)'),
      (m) => '${m[1]}*${m[2]}',
    );

    // if DEG convert sin(x) -> sin(x*pi/180)
    if (angleMode == AngleMode.degrees) {
      expression = expression
          .replaceAllMapped(
            RegExp(r'sin\(([^)]+)\)'),
            (m) => 'sin((${m[1]})*pi/180)',
          )
          .replaceAllMapped(
            RegExp(r'cos\(([^)]+)\)'),
            (m) => 'cos((${m[1]})*pi/180)',
          )
          .replaceAllMapped(
            RegExp(r'tan\(([^)]+)\)'),
            (m) => 'tan((${m[1]})*pi/180)',
          );
    }

    try {
      final exp = _parser.parse(expression);
      final value = exp.evaluate(EvaluationType.REAL, _context);
      if (value is double) return value;
      return (value as num).toDouble();
    } on Exception {
      throw const FormatException('Invalid expression');
    }
  }
}
