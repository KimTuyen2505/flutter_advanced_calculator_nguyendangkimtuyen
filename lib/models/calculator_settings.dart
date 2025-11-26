import 'package:flutter/material.dart';
import 'calculator_mode.dart';

class CalculatorSettings {
  final int decimalPrecision;
  final AngleMode angleMode;
  final ThemeMode themeMode;
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize; 

  const CalculatorSettings({
    this.decimalPrecision = 4,
    this.angleMode = AngleMode.degrees,
    this.themeMode = ThemeMode.system,
    this.hapticFeedback = true,
    this.soundEffects = false,
    this.historySize = 50,
  });

  CalculatorSettings copyWith({
    int? decimalPrecision,
    AngleMode? angleMode,
    ThemeMode? themeMode,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
  }) {
    return CalculatorSettings(
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      angleMode: angleMode ?? this.angleMode,
      themeMode: themeMode ?? this.themeMode,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      historySize: historySize ?? this.historySize,
    );
  }

  Map<String, dynamic> toJson() => {
    'decimalPrecision': decimalPrecision,
    'angleMode': angleMode.name,
    'themeMode': themeMode.name,
    'hapticFeedback': hapticFeedback,
    'soundEffects': soundEffects,
    'historySize': historySize,
  };

  factory CalculatorSettings.fromJson(Map<String, dynamic> json) {
    return CalculatorSettings(
      decimalPrecision: json['decimalPrecision'] ?? 4,
      angleMode: AngleMode.values.firstWhere(
        (m) => m.name == json['angleMode'],
        orElse: () => AngleMode.degrees,
      ),
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      hapticFeedback: json['hapticFeedback'] ?? true,
      soundEffects: json['soundEffects'] ?? false,
      historySize: json['historySize'] ?? 50,
    );
  }
}
