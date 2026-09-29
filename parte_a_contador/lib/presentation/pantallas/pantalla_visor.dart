import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';
import 'pantalla_control.dart';

class PantallaVisor extends ConsumerWidget {
  const PantallaVisor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contador = ref.watch(contadorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor del Contador'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contador: $contador',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaControl(),
                  ),
                );
              },
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}
