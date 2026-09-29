import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatefulWidget {
  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  const PantallaVisor({
    super.key,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _contador = 0;

  @override
  void initState() {
    super.initState();
    _cargarContador();
  }

  Future<void> _cargarContador() async {
    final valor = await widget.obtenerContador();
    if (mounted) {
      setState(() {
        _contador = valor;
      });
    }
  }

  Future<void> _irAControl() async {
    final nuevoValor = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaControl(
          valorInicial: _contador,
          obtenerContador: widget.obtenerContador,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );

    if (nuevoValor != null && mounted) {
      setState(() {
        _contador = nuevoValor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Contador: $_contador',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _irAControl,
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}
