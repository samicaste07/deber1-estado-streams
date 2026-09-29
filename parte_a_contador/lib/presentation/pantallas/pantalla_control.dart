import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';

class PantallaControl extends ConsumerWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contador = ref.watch(contadorProvider);
    final notifier = ref.read(contadorProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control del Contador'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Valor actual: $contador',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => notifier.decrementar(),
                  child: const Text('-1'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => notifier.incrementar(),
                  child: const Text('+1'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}
