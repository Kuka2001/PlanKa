import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'features/dashboard/dashboard_demo_screen.dart';

void main() {
  runApp(const SmartFinanceCoachApp());
}

class SmartFinanceCoachApp extends StatelessWidget {
  const SmartFinanceCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Finance Coach',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardDemoScreen(),
    );
  }
}
