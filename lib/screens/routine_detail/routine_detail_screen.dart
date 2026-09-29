import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/routine.dart';
import '../../providers/progress_provider.dart';
import '../../providers/routine_provider.dart';
import '../routines/create_routine_screen.dart';

class RoutineDetailScreen extends ConsumerWidget {
  final Routine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final count = progress.completedCount(routine.id);
    final ratio = routine.steps.isEmpty ? 0.0 : count / routine.steps.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(routine.name),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateRoutineScreen(routine: routine)))),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Supprimer la routine ?'),
                  content: Text('La routine « ${routine.name} » sera supprimée.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Annuler')),
                    FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Supprimer')),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                ref.read(routineProvider).removeRoutine(routine.id);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(routine.icon, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 8),
          Text('🔥 ${routine.currentStreak} jours consécutifs', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: ratio, minHeight: 10)),
          const SizedBox(height: 8),
          Text('$count/${routine.steps.length} étapes terminées'),
          const SizedBox(height: 20),
          ...routine.steps.map((step) => Card(
                child: CheckboxListTile(
                  value: progress.isCompleted(routine.id, step.id),
                  onChanged: (_) => ref.read(progressProvider).toggle(routine.id, step.id),
                  secondary: Text(step.emoji, style: const TextStyle(fontSize: 25)),
                  title: Text(step.title),
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              )),
          if (count == routine.steps.length && routine.steps.isNotEmpty) ...[
            const SizedBox(height: 20),
            Card(color: Colors.green.shade50, child: const Padding(padding: EdgeInsets.all(18), child: Row(children: [Text('🎉', style: TextStyle(fontSize: 30)), SizedBox(width: 12), Expanded(child: Text('Routine terminée ! +50 XP', style: TextStyle(fontWeight: FontWeight.w700)))]))),
          ],
        ],
      ),
    );
  }
}
