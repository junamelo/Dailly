import 'package:flutter/material.dart';
import '../../models/routine.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;
  const RoutineDetailScreen({super.key, required this.routine});
  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  late final List<bool> _completed;
  @override
  void initState() { super.initState(); _completed = List<bool>.filled(widget.routine.steps.length, false); }
  @override
  Widget build(BuildContext context) {
    final routine = widget.routine;
    final count = _completed.where((value) => value).length;
    final progress = routine.steps.isEmpty ? 0.0 : count / routine.steps.length;
    return Scaffold(
      appBar: AppBar(title: Text(routine.name)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(routine.icon, style: const TextStyle(fontSize: 56)),
        const SizedBox(height: 8),
        Text('🔥 ${routine.currentStreak} jours consécutifs', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 24),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 10)),
        const SizedBox(height: 8), Text('$count/${routine.steps.length} étapes terminées'), const SizedBox(height: 20),
        ...routine.steps.asMap().entries.map((entry) {
          final index = entry.key; final step = entry.value;
          return Card(child: CheckboxListTile(value: _completed[index], onChanged: (value) => setState(() => _completed[index] = value ?? false), secondary: Text(step.emoji, style: const TextStyle(fontSize: 25)), title: Text(step.title), controlAffinity: ListTileControlAffinity.trailing));
        }),
        if (count == routine.steps.length && routine.steps.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(color: Colors.green.shade50, child: const Padding(padding: EdgeInsets.all(18), child: Row(children: [Text('🎉', style: TextStyle(fontSize: 30)), SizedBox(width: 12), Expanded(child: Text('Routine terminée ! +50 XP', style: TextStyle(fontWeight: FontWeight.w700)))]))),
        ],
      ]),
    );
  }
}
