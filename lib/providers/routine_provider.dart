import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit_step.dart';
import '../models/routine.dart';

final routineProvider = Provider<List<Routine>>((ref) {
  return const [
    Routine(
      id: 'morning',
      name: 'Routine du matin',
      icon: '🌅',
      colorValue: 0xFFFFB347,
      currentStreak: 3,
      steps: [
        HabitStep(id: 'wake-up', title: 'Se lever', emoji: '⏰', position: 0),
        HabitStep(
          id: 'water',
          title: 'Boire un verre d’eau',
          emoji: '💧',
          position: 1,
        ),
        HabitStep(
          id: 'teeth',
          title: 'Se brosser les dents',
          emoji: '🪥',
          position: 2,
        ),
      ],
    ),
  ];
});
