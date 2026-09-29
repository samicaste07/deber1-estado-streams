import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class PantallaControl extends StatefulWidget {
  final int valorInicial;
  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  const PantallaControl({
    super.key,
    required this.valorInicial,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador;

  @override
  void initState() {
    super.initState();
    _contador = widget.valorInicial;
  }

  Future<void> _incrementar() async {
    final nuevoValor = await widget.incrementar();
    if (mounted) {
      setState(() {
        _contador = nuevoValor;
      });
    }
  }

  Future<void> _decrementar() async {
    final nuevoValor = await widget.decrementar();
    if (mounted) {
      setState(() {
        _contador = nuevoValor;
      });
    }
  }

  void _volver() {
    Navigator.pop(context, _contador);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _contador);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Control del Contador'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _volver,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Valor actual: $_contador',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _decrementar,
                    child: const Text('-1'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _incrementar,
                    child: const Text('+1'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _volver, child: const Text('Volver')),
            ],
          ),
        ),
      ),
    );
  }
}
