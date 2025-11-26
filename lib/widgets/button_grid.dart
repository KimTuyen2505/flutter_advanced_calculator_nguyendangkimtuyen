import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calc, _) {
        switch (calc.mode) {
          case CalculatorMode.basic:
            return _buildBasic(context, calc);
          case CalculatorMode.scientific:
            return _buildScientific(context, calc);
          case CalculatorMode.programmer:
            return _buildProgrammer(context, calc);
        }
      },
    );
  }
//basic
  Widget _buildBasic(BuildContext context, CalculatorProvider calc) {
    final buttons = [
      ['C', 'CE', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
    ];

    return _buildGrid(
      rows: buttons.length,
      columns: 4,
      buttons: buttons,
      handler: (label) {
        switch (label) {
          case 'C':
            calc.clear();
            break;
          case 'CE':
            calc.clearEntry();
            break;
          case '%':
            calc.addPercentage();
            break;
          case '÷':
          case '×':
          case '+':
          case '-':
          case '.':
            calc.addToExpression(label);
            break;
          case '±':
            calc.toggleSign();
            break;
          case '=':
            calc.calculate();
            break;
          default:
            calc.addToExpression(label);
        }
      },
    );
  }

  //scientific
  Widget _buildScientific(BuildContext context, CalculatorProvider calc) {
    final buttons = [
      ['2nd', 'sin', 'cos', 'tan', 'Ln', 'log'],
      ['x²', '√', 'x^y', '(', ')', '÷'],
      ['MC', '7', '8', '9', 'C', '×'],
      ['MR', '4', '5', '6', 'CE', '-'],
      ['M+', '1', '2', '3', '%', '+'],
      ['M-', '±', '0', '.', 'Π', '='],
    ];

    return _buildGrid(
      rows: buttons.length,
      columns: 6,
      buttons: buttons,
      handler: (label) {
        switch (label) {
          case 'C':
            calc.clear();
            break;
          case 'CE':
            calc.clearEntry();
            break;
          case '%':
            calc.addPercentage();
            break;
          case '÷':
          case '×':
          case '+':
          case '-':
          case '(':
          case ')':
          case '.':
          case 'x^y':
            calc.addToExpression(
              label == 'x^y' ? '^' : (label == 'Π' ? 'π' : label),
            );
            break;
          case '±':
            calc.toggleSign();
            break;
          case '=':
            calc.calculate();
            break;
          // scientific
          case 'sin':
          case 'cos':
          case 'tan':
          case 'Ln':
          case 'log':
          case 'x²':
          case '√':
          case 'Π':
            calc.addScientificFunction(
              label == 'Ln' ? 'ln' : (label == 'Π' ? 'π' : label),
            );
            break;
          // memory
          case 'M+':
            calc.memoryAdd();
            break;
          case 'M-':
            calc.memorySubtract();
            break;
          case 'MR':
            calc.memoryRecall();
            break;
          case 'MC':
            calc.memoryClear();
            break;
          case '2nd':
            break;
          default:
            calc.addToExpression(label);
        }
      },
    );
  }

  // PROGRAMMER
  Widget _buildProgrammer(BuildContext context, CalculatorProvider calc) {
    final buttons = [
      ['BIN', 'OCT', 'DEC', 'HEX'],
      ['A', 'B', 'C', 'D'],
      ['E', 'F', '0', '1'],
      ['2', '3', '4', '5'],
      ['6', '7', '8', '9'],
      ['AND', 'OR', 'XOR', 'NOT'],
      ['<<', '>>', 'CE', '='],
    ];

    return _buildGrid(
      rows: buttons.length,
      columns: 4,
      buttons: buttons,
      handler: (label) {
        switch (label) {
          // choose base
          case 'BIN':
            calc.setProgrammerBase(ProgrammerBase.bin);
            break;
          case 'OCT':
            calc.setProgrammerBase(ProgrammerBase.oct);
            break;
          case 'DEC':
            calc.setProgrammerBase(ProgrammerBase.dec);
            break;
          case 'HEX':
            calc.setProgrammerBase(ProgrammerBase.hex);
            break;

          // bitwise binary
          case 'AND':
          case 'OR':
          case 'XOR':
            calc.programmerBinaryOp(label);
            break;

          // unary
          case 'NOT':
            calc.programmerUnary('NOT');
            break;
          case '<<':
            calc.programmerUnary('<<');
            break;
          case '>>':
            calc.programmerUnary('>>');
            break;

          // CE & =
          case 'CE':
            calc.programmerBackspace();
            break;
          case '=':
            calc.programmerEquals();
            break;

          // input 0–9, A–F
          default:
            calc.programmerInput(label);
        }
      },
    );
  }

  // COMMON GRID BUILDER
  Widget _buildGrid({
    required int rows,
    required int columns,
    required List<List<String>> buttons,
    required void Function(String) handler,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.screenPadding / 2),
      child: GridView.builder(
        itemCount: rows * columns,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: AppDimens.buttonSpacing,
          crossAxisSpacing: AppDimens.buttonSpacing,
        ),
        itemBuilder: (context, index) {
          final r = index ~/ columns;
          final c = index % columns;
          final label = buttons[r][c];
          final isAccent = [
            '=',
            '+',
            '-',
            '×',
            '÷',
            'AND',
            'OR',
            'XOR',
          ].contains(label);

          return CalculatorButton(
            label: label,
            isAccent: isAccent,
            onTap: () => handler(label),
          );
        },
      ),
    );
  }
}
