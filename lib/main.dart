import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/app/quiz/intro/view.dart';
import 'package:quiz_stepper_poc/framework/theme/app_theme.dart';
import 'package:quiz_stepper_poc/framework/utils/app_navigator.dart';

void main() {
  runApp(const QuizStepperApp());
}

class QuizStepperApp extends StatelessWidget {
  const QuizStepperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '¿Qué tipo de viajero sos?',
      navigatorKey: AppNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppTheme.COLOR_SAND,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.COLOR_OCEAN,
          primary: AppTheme.COLOR_OCEAN,
          surface: AppTheme.COLOR_SAND,
        ),
        useMaterial3: true,
      ),
      home: const IntroView(),
    );
  }
}
