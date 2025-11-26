import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isAccent;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isAccent = false,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _pressDown(_) {
    setState(() => _scale = 0.9);
  }

  void _pressUp(_) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isAccent
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.surfaceVariant;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.buttonSpacing / 2),
      child: AnimatedScale(
        duration: AppDurations.buttonPress,
        scale: _scale,
        child: GestureDetector(
          onTapDown: _pressDown,
          onTapUp: _pressUp,
          onTapCancel: () => setState(() => _scale = 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
