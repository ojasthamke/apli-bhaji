import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Database initialization happens lazily when DatabaseHelper.instance.database is accessed.
  // We can also initialize it here if needed.

  runApp(
    const ProviderScope(
      child: ApliBhajiApp(),
    ),
  );
}

class ApliBhajiApp extends StatelessWidget {
  const ApliBhajiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APLI BHAJI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
