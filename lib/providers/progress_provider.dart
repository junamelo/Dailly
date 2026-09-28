import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';

final progressProvider = ChangeNotifierProvider<ProgressController>((ref) {
  return ProgressController();
});

class ProgressController extends ChangeNotifier {
  final Map<String, Set<String>> _completed = {};
  final Box _box = Hive.box('daily_life');

  ProgressController() {
    _load();
  }

  bool isCompleted(String routineId, String stepId) => _completed[routineId]?.contains(stepId) ?? false;

  int completedCount(String routineId) => _completed[routineId]?.length ?? 0;

  int get totalXp => _completed.values.fold(0, (sum, steps) => sum + steps.length) * 10;

  int get level => (totalXp ~/ 100) + 1;

  int get levelProgress => totalXp % 100;

  void toggle(String routineId, String stepId) {
    final steps = _completed.putIfAbsent(routineId, () => <String>{});
    if (!steps.add(stepId)) steps.remove(stepId);
    _save();
    notifyListeners();
  }

  void _load() {
    final raw = _box.get('completed_steps');
    if (raw is! String) return;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return;
    for (final entry in decoded.entries) {
      final values = entry.value;
      if (values is List) _completed[entry.key.toString()] = values.map((value) => value.toString()).toSet();
    }
  }

  Future<void> _save() async {
    final data = _completed.map((key, value) => MapEntry(key, value.toList()));
    await _box.put('completed_steps', jsonEncode(data));
  }
}
