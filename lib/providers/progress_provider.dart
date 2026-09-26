import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressProvider = ChangeNotifierProvider<ProgressController>((ref) {
  return ProgressController();
});

class ProgressController extends ChangeNotifier {
  final Map<String, Set<String>> _completed = {};

  bool isCompleted(String routineId, String stepId) => _completed[routineId]?.contains(stepId) ?? false;

  int completedCount(String routineId) => _completed[routineId]?.length ?? 0;

  void toggle(String routineId, String stepId) {
    final steps = _completed.putIfAbsent(routineId, () => <String>{});
    if (!steps.add(stepId)) steps.remove(stepId);
    notifyListeners();
  }
}
