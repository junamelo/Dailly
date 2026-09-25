import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'screens/today/today_screen.dart';

void main() {
  runApp(const ProviderScope(child: DailyLifeApp()));
}

class DailyLifeApp extends StatelessWidget {
  const DailyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DailyLife',
      theme: AppTheme.light,
      home: const TodayScreen(),
    );
  }
}
