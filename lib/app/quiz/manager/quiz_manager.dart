class QuizManager {
  static final QuizManager _instance = QuizManager._internal();
  factory QuizManager() => _instance;
  QuizManager._internal();

  final Map<String, dynamic> answers = {};
  final Map<String, int> profileScores = {
    'mochilero': 0,
    'resort': 0,
    'cultural': 0,
    'gastronomico': 0,
  };

  void reset() {
    answers.clear();
    profileScores.updateAll((_, _) => 0);
  }

  void recordAnswer({
    required String key,
    required String value,
    required Map<String, int> scoreDelta,
  }) {
    answers[key] = value;
    scoreDelta.forEach((profile, delta) {
      profileScores[profile] = (profileScores[profile] ?? 0) + delta;
    });
  }

  String get winningProfile =>
      profileScores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
}
