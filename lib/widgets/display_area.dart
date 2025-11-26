import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';

class DisplayArea extends StatelessWidget {
  final VoidCallback? onSwipeUp;

  const DisplayArea({super.key, this.onSwipeUp});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calc, _) {
        final isProgrammer = calc.mode == CalculatorMode.programmer;

        final mainText = isProgrammer
            ? calc.programmerDisplay
            : (calc.expression.isEmpty ? '0' : calc.expression);

        final subText = isProgrammer
            ? 'BASE: ${calc.programmerBase.name.toUpperCase()}'
            : calc.result;

        return GestureDetector(
          onHorizontalDragEnd: (_) => calc.deleteLast(),
          onVerticalDragEnd: (_) => onSwipeUp?.call(),
          child: AnimatedContainer(
            duration: AppDurations.modeSwitch,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(AppDimens.screenPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.displayRadius),
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    mainText,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedOpacity(
                  opacity: (!isProgrammer && calc.error != null) ? 0.3 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    subText,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                if (!isProgrammer && calc.error != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    calc.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
