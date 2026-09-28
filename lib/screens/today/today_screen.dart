import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/routine.dart';
import '../../providers/routine_provider.dart';
import '../../providers/progress_provider.dart';
import '../routine_detail/routine_detail_screen.dart';
import '../routines/create_routine_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider).routines;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('DailyLife', style: TextStyle(fontWeight: FontWeight.w700)), actions: [IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateRoutineScreen())), icon: const Icon(Icons.add))]),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 32), children: [
        Text('Bonjour 👋', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Voici tes routines pour aujourd’hui.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 28),
        Text('Mes routines', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (routines.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const Text('🌱', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text('Aucune routine pour le moment', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Crée une routine pour commencer ta journée.', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton.icon(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateRoutineScreen())), icon: const Icon(Icons.add), label: const Text('Créer une routine')),
              ]),
            ),
          )
        else
          for (final routine in routines) _RoutineCard(routine: routine),
      ]),
    );
  }
}

class _RoutineCard extends ConsumerWidget {
  final Routine routine;
  const _RoutineCard({required this.routine});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(routine.colorValue);
    final completed = ref.watch(progressProvider).completedCount(routine.id);
    final progress = routine.steps.isEmpty ? 0.0 : completed / routine.steps.length;
    final open = () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)));
    return Dismissible(
      key: ValueKey(routine.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(24)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => ref.read(routineProvider).removeRoutine(routine.id),
      child: Card(
      color: color.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(borderRadius: BorderRadius.circular(24), onTap: open, child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        Row(children: [
          Container(width: 52, height: 52, alignment: Alignment.center, decoration: BoxDecoration(color: color.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(16)), child: Text(routine.icon, style: const TextStyle(fontSize: 28))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(routine.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text('$completed/${routine.steps.length} étapes')])),
          Text('🔥 ${routine.currentStreak}'),
        ]),
        const SizedBox(height: 16),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: const Color(0x33FFFFFF))),
        const SizedBox(height: 14),
        Align(alignment: Alignment.centerRight, child: FilledButton.tonal(onPressed: open, child: const Text('Commencer'))),
      ]))),
      ),
    );
  }
}
