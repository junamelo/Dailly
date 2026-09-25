import 'habit_step.dart';

class Routine {
  final String id;
  final String name;
  final String icon;
  final int colorValue;
  final List<HabitStep> steps;
  final int currentStreak;

  const Routine({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.steps,
    this.currentStreak = 0,
  });
}
