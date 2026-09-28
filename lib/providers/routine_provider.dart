import 'package:flutter_riverpod/legacy.dart';
import '../models/habit_step.dart';
import '../models/routine.dart';

final routineProvider = ChangeNotifierProvider<RoutineController>((ref) => RoutineController());

class RoutineController extends ChangeNotifier {
  final List<Routine> routines = [
    const Routine(id: 'morning', name: 'Routine du matin', icon: '🌅', colorValue: 0xFFFFB347, currentStreak: 3, steps: [
      HabitStep(id: 'wake-up', title: 'Se lever', emoji: '⏰', position: 0),
      HabitStep(id: 'water', title: 'Boire un verre d’eau', emoji: '💧', position: 1),
      HabitStep(id: 'teeth', title: 'Se brosser les dents', emoji: '🪥', position: 2),
    ]),
  ];

  void addRoutine({required String name, required String icon, required List<String> stepNames}) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    routines.add(Routine(id: id, name: name, icon: icon, colorValue: 0xFF9B8AFB, steps: [
      for (var i = 0; i < stepNames.length; i++) HabitStep(id: '$id-$i', title: stepNames[i], emoji: '✅', position: i),
    ]));
    notifyListeners();
  }
}
