import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calculator_settings.dart';
import '../models/calculator_mode.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final theme = context.watch<ThemeProvider>();
    final settings = calc.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: theme.themeMode,
              items: ThemeMode.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  theme.setTheme(value);
                  calc.updateSettings(settings.copyWith(themeMode: value));
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Decimal precision'),
            subtitle: Text('${settings.decimalPrecision} digits'),
            trailing: DropdownButton<int>(
              value: settings.decimalPrecision,
              items: [2, 3, 4, 5, 6, 7, 8, 9, 10]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  calc.updateSettings(settings.copyWith(decimalPrecision: v));
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Angle mode'),
            trailing: DropdownButton<AngleMode>(
              value: calc.angleMode,
              items: AngleMode.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  calc.setAngleMode(v);
                  calc.updateSettings(settings.copyWith(angleMode: v));
                }
              },
            ),
          ),
          ListTile(
            title: const Text('History size'),
            trailing: DropdownButton<int>(
              value: settings.historySize,
              items: [25, 50, 100]
                  .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  calc.updateSettings(settings.copyWith(historySize: v));
                }
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Haptic feedback'),
            value: settings.hapticFeedback,
            onChanged: (v) =>
                calc.updateSettings(settings.copyWith(hapticFeedback: v)),
          ),
          SwitchListTile(
            title: const Text('Sound effects'),
            value: settings.soundEffects,
            onChanged: (v) =>
                calc.updateSettings(settings.copyWith(soundEffects: v)),
          ),
        ],
      ),
    );
  }
}
