import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calculator_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorProvider>(
      builder: (context, calc, _) {
        final modes = CalculatorMode.values;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
          ),
          child: AnimatedSwitcher(
            duration: AppDurations.modeSwitch,
            child: Row(
              key: ValueKey(calc.mode),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: modes.map((mode) {
                final selected = mode == calc.mode;
                return Expanded(
                  child: GestureDetector(
                    // 🔴 CHỖ NÀY TRƯỚC ĐANG LÀ toggleMode(...)
                    onTap: () => calc.setMode(mode),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimens.buttonRadius,
                        ),
                        color: selected
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.transparent,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        mode.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
