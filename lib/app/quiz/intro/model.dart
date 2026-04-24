import 'package:flutter/foundation.dart';
import 'package:quiz_stepper_poc/app/quiz/manager/quiz_manager.dart';

class IntroViewModel extends ChangeNotifier {
  final QuizManager manager = QuizManager();

  bool isReady = false;

  void init() {
    manager.reset();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!hasListeners) return;
      isReady = true;
      notifyListeners();
    });
  }
}
