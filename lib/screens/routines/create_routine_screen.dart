import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/routine_provider.dart';

class CreateRoutineScreen extends ConsumerStatefulWidget {
  const CreateRoutineScreen({super.key});
  @override
  ConsumerState<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends ConsumerState<CreateRoutineScreen> {
  final nameController = TextEditingController();
  final steps = <TextEditingController>[TextEditingController()];
  String icon = '✨';
  @override
  void dispose() { nameController.dispose(); for (final c in steps) c.dispose(); super.dispose(); }
  void save() {
    final name = nameController.text.trim();
    final values = steps.map((c) => c.text.trim()).where((v) => v.isNotEmpty).toList();
    if (name.isEmpty || values.isEmpty) return;
    ref.read(routineProvider).addRoutine(name: name, icon: icon, stepNames: values);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nouvelle routine')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom de la routine', border: OutlineInputBorder())),
      const SizedBox(height: 18),
      DropdownButtonFormField<String>(value: icon, decoration: const InputDecoration(labelText: 'Icône', border: OutlineInputBorder()), items: ['✨', '🌅', '💼', '🌙', '💪', '📚'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 24)))).toList(), onChanged: (v) => setState(() => icon = v ?? icon)),
      const SizedBox(height: 24),
      const Text('Étapes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      ...steps.asMap().entries.map((entry) => Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: entry.value, decoration: InputDecoration(labelText: 'Étape ${entry.key + 1}', border: const OutlineInputBorder(), prefixText: '✅  ')))),
      TextButton.icon(onPressed: () => setState(() => steps.add(TextEditingController())), icon: const Icon(Icons.add), label: const Text('Ajouter une étape')),
      const SizedBox(height: 20),
      FilledButton(onPressed: save, child: const Text('Enregistrer la routine')),
    ]),
  );
}
