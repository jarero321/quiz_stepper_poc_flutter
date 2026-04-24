import 'package:flutter/foundation.dart';
import 'package:quiz_stepper_poc/app/quiz/manager/quiz_manager.dart';

class IntroViewModel extends ChangeNotifier {
  // ─── Dependencies ───
  final QuizManager manager = QuizManager();

  // ─── State ───
  bool isReady = false;

  // ─── Methods ───
  void init() {
    manager.reset();
    Future.delayed(const Duration(milliseconds: 120), () {
      // Widget may have been disposed before the delay fires.
      if (!hasListeners) return;
      isReady = true;
      notifyListeners();
    });
  }
}
