import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/routine_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Progression', style: TextStyle(fontWeight: FontWeight.w700))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text('Ton évolution', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          Card(
            color: theme.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Niveau 1', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('0 / 100 XP'),
                const SizedBox(height: 12),
                ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 0, minHeight: 10)),
              ]),
            ),
          ),
          const SizedBox(height: 28),
          Text('Mes streaks', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...routines.map((routine) => Card(child: ListTile(leading: Text(routine.icon, style: const TextStyle(fontSize: 28)), title: Text(routine.name), trailing: Text('🔥 ${routine.currentStreak} jours', style: const TextStyle(fontWeight: FontWeight.w600))))),
          const SizedBox(height: 28),
          Text('Badges', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Text('🌱', style: TextStyle(fontSize: 28)), title: Text('Première routine'), subtitle: Text('Complète ta première routine pour débloquer ce badge'))),
        ],
      ),
    );
  }
}
