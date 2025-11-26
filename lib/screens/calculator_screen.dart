import 'package:flutter/material.dart';
import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import '../widgets/mode_selector.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'graph_screen.dart';  

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DisplayArea(
              onSwipeUp: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
            ),
            const ModeSelector(),
            const Expanded(child: ButtonGrid()),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),

          //draw new chart
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: "Vẽ đồ thị hàm số",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GraphScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
