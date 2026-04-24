import 'package:flutter/material.dart';
import 'package:quiz_stepper_poc/app/quiz/manager/quiz_manager.dart';

class TravelerProfile {
  const TravelerProfile({
    required this.key,
    required this.title,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
  });

  final String key;
  final String title;
  final String tagline;
  final String description;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
}

class ResultViewModel extends ChangeNotifier {
  // ─── Dependencies ───
  final QuizManager manager = QuizManager();

  // ─── Catalog ───
  static const Map<String, TravelerProfile> _profiles = {
    'mochilero': TravelerProfile(
      key: 'mochilero',
      title: 'Mochilero',
      tagline: 'La ruta es el destino.',
      description:
          'Viajas ligero, buscas lo inesperado y mides el viaje en historias, no en estrellas.',
      icon: Icons.hiking_rounded,
      gradientStart: Color(0xFF2E7D32),
      gradientEnd: Color(0xFF1B5E20),
    ),
    'resort': TravelerProfile(
      key: 'resort',
      title: 'Playero',
      tagline: 'Ya chambeo demasiado, ahora me toca a mí.',
      description:
          'Quieres desconectar sin broncas: alberca, tragos en el camastro, buffet abierto y nada que decidir.',
      icon: Icons.beach_access_rounded,
      gradientStart: Color(0xFFFF7043),
      gradientEnd: Color(0xFFE64A19),
    ),
    'cultural': TravelerProfile(
      key: 'cultural',
      title: 'Cultural',
      tagline: 'Cada ciudad es una clase magistral.',
      description:
          'Museos, centros históricos, caminatas con audioguía. Regresas sabiendo más de lo que llevabas.',
      icon: Icons.museum_rounded,
      gradientStart: Color(0xFF6A1B9A),
      gradientEnd: Color(0xFF4A148C),
    ),
    'gastronomico': TravelerProfile(
      key: 'gastronomico',
      title: 'Foodie',
      tagline: 'Tu itinerario es un mapa de reservas.',
      description:
          'Mercados, cantinas, tacos al pastor, mezcal y café de olla. El viaje se cuenta en sabores.',
      icon: Icons.restaurant_rounded,
      gradientStart: Color(0xFFC2185B),
      gradientEnd: Color(0xFF880E4F),
    ),
  };

  // ─── State ───
  bool isRevealed = false;

  // ─── Getters ───
  TravelerProfile get profile =>
      _profiles[manager.winningProfile] ?? _profiles['mochilero']!;

  int get totalScore =>
      manager.profileScores.values.fold<int>(0, (a, b) => a + b);

  double scoreRatio(String key) {
    final score = manager.profileScores[key] ?? 0;
    return totalScore == 0 ? 0 : score / totalScore;
  }

  List<TravelerProfile> get allProfiles => _profiles.values.toList();

  // ─── Methods ───
  void reveal() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!hasListeners) return;
      isRevealed = true;
      notifyListeners();
    });
  }

  void restart() => manager.reset();
}
