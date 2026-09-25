import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/routine.dart';
import '../../providers/routine_provider.dart';
import '../routine_detail/routine_detail_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('DailyLife', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 32), children: [
        Text('Bonjour 👋', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('Voici tes routines pour aujourd’hui.', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 28),
        Text('Mes routines', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (final routine in routines) _RoutineCard(routine: routine),
      ]),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final Routine routine;
  const _RoutineCard({required this.routine});
  @override
  Widget build(BuildContext context) {
    final color = Color(routine.colorValue);
    final open = () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)));
    return Card(
      color: color.withValues(alpha: 0.16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(borderRadius: BorderRadius.circular(24), onTap: open, child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
        Row(children: [
          Container(width: 52, height: 52, alignment: Alignment.center, decoration: BoxDecoration(color: color.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(16)), child: Text(routine.icon, style: const TextStyle(fontSize: 28))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(routine.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text('0/${routine.steps.length} étapes')])),
          Text('🔥 ${routine.currentStreak}'),
        ]),
        const SizedBox(height: 16),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 0, minHeight: 8, backgroundColor: Color(0x33FFFFFF))),
        const SizedBox(height: 14),
        Align(alignment: Alignment.centerRight, child: FilledButton.tonal(onPressed: open, child: const Text('Commencer'))),
      ]))),
    );
  }
}
