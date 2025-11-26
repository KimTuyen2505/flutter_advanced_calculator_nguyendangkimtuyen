import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/calculator_settings.dart';
import 'providers/calculator_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'services/storage_service.dart';
import 'utils/expression_parser.dart';
import 'screens/calculator_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final historyProvider = HistoryProvider(storage);
  await historyProvider.load();

  final settingsJson = await storage.readSettings();
  final settings = settingsJson != null
      ? CalculatorSettings.fromJson(settingsJson)
      : const CalculatorSettings();

  runApp(
    MyApp(
      storage: storage,
      historyProvider: historyProvider,
      settings: settings,
    ),
  );
}

class MyApp extends StatelessWidget {
  final StorageService storage;
  final HistoryProvider historyProvider;
  final CalculatorSettings settings;

  const MyApp({
    super.key,
    required this.storage,
    required this.historyProvider,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..setTheme(settings.themeMode),
        ),
        ChangeNotifierProvider(create: (_) => historyProvider),
        ChangeNotifierProxyProvider<HistoryProvider, CalculatorProvider>(
          create: (_) => CalculatorProvider(
            parser: ExpressionParser(),
            storage: storage,
            historyProvider: historyProvider,
            initialSettings: settings,
          ),
          update: (_, history, previous) =>
              previous ??
              CalculatorProvider(
                parser: ExpressionParser(),
                storage: storage,
                historyProvider: history,
                initialSettings: settings,
              ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
            themeMode: theme.themeMode,
            home: const CalculatorScreen(),
          );
        },
      ),
    );
  }
}
