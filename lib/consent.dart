import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConsentDialog extends StatefulWidget {
  const ConsentDialog({super.key});

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _optIn = false;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('innstillinger');
    _optIn = box.get('analytics_opt_in', defaultValue: false) as bool;
  }

  void _save(bool value) async {
    final box = Hive.box('innstillinger');
    await box.put('analytics_opt_in', value);
    if (!mounted) return;
    Navigator.of(context).pop();
    final snack = value ? 'Takk — analyse aktivert.' : 'Analyse deaktivert.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personvern'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vi bruker anonymisert analyse for å forbedre appen. Du kan velge å slå dette på eller av.'),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Samtykke til anonym analyse'),
            const Spacer(),
            Switch(value: _optIn, onChanged: (v) => setState(() => _optIn = v))
          ])
        ],
      ),
      // Build actions and interactive switch outside of const children
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Avbryt')),
        ElevatedButton(onPressed: () => _save(_optIn), child: const Text('Lagre'))
      ],
    );
  }
}
