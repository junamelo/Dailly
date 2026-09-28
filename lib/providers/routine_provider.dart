import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/habit_step.dart';
import '../models/routine.dart';

final routineProvider = ChangeNotifierProvider<RoutineController>((ref) => RoutineController());

class RoutineController extends ChangeNotifier {
  final List<Routine> routines = [];
  final Box _box = Hive.box('daily_life');

  RoutineController() {
    _load();
  }

  void _load() {
    final saved = _box.get('routines');
    if (saved is String) {
      final decoded = jsonDecode(saved);
      if (decoded is List) {
        routines.addAll(decoded.whereType<Map>().map(_fromJson));
      }
    }
    if (routines.isEmpty) {
      routines.add(const Routine(id: 'morning', name: 'Routine du matin', icon: '🌅', colorValue: 0xFFFFB347, currentStreak: 3, steps: [
        HabitStep(id: 'wake-up', title: 'Se lever', emoji: '⏰', position: 0),
        HabitStep(id: 'water', title: 'Boire un verre d’eau', emoji: '💧', position: 1),
        HabitStep(id: 'teeth', title: 'Se brosser les dents', emoji: '🪥', position: 2),
      ]));
    }
  }

  void addRoutine({required String name, required String icon, required List<String> stepNames}) {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    routines.add(Routine(id: id, name: name, icon: icon, colorValue: 0xFF9B8AFB, steps: [
      for (var i = 0; i < stepNames.length; i++) HabitStep(id: '$id-$i', title: stepNames[i], emoji: '✅', position: i),
    ]));
    _save();
    notifyListeners();
  }

  void removeRoutine(String id) {
    routines.removeWhere((routine) => routine.id == id);
    _save();
    notifyListeners();
  }

  Future<void> _save() async => _box.put('routines', jsonEncode(routines.map(_toJson).toList()));

  Map<String, dynamic> _toJson(Routine r) => {'id': r.id, 'name': r.name, 'icon': r.icon, 'color': r.colorValue, 'streak': r.currentStreak, 'steps': r.steps.map((s) => {'id': s.id, 'title': s.title, 'emoji': s.emoji, 'position': s.position}).toList()};

  Routine _fromJson(Map data) => Routine(
    id: data['id'].toString(), name: data['name'].toString(), icon: data['icon'].toString(), colorValue: data['color'] as int, currentStreak: (data['streak'] as int?) ?? 0,
    steps: (data['steps'] as List).whereType<Map>().map((s) => HabitStep(id: s['id'].toString(), title: s['title'].toString(), emoji: s['emoji'].toString(), position: s['position'] as int)).toList(),
  );
}
