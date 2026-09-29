import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  final ConsultarConexion consultarConexion;

  const PantallaFoto({super.key, required this.consultarConexion});

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _cargando = false;

  Future<void> _consultar() async {
    setState(() {
      _cargando = true;
    });

    final resultado = await widget.consultarConexion();
    final ahora = DateTime.now();

    if (!mounted) return;

    setState(() {
      _estado = resultado;
      _horaConsulta = ahora;
      _cargando = false;
    });
  }

  String _formatearHora(DateTime fecha) {
    final horas = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final segundos = fecha.second.toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }

  (String, IconData, Color) _obtenerDetallesVisuales(EstadoConexion estado) {
    switch (estado) {
      case EstadoConexion.wifi:
        return ('Wi-Fi', Icons.wifi, Colors.green);
      case EstadoConexion.datosMoviles:
        return ('Datos moviles', Icons.signal_cellular_alt, Colors.green);
      case EstadoConexion.otro:
        return ('Otro', Icons.device_hub, Colors.green);
      case EstadoConexion.sinConexion:
        return ('Sin conexion', Icons.wifi_off, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detalles = _estado != null
        ? _obtenerDetallesVisuales(_estado!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado de Conexión (Foto)'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_cargando)
                const CircularProgressIndicator()
              else if (detalles != null) ...[
                Icon(detalles.$2, size: 96, color: detalles.$3),
                const SizedBox(height: 16),
                Text(
                  detalles.$1,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: detalles.$3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                if (_horaConsulta != null)
                  Text(
                    'Hora de consulta: ${_formatearHora(_horaConsulta!)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ] else ...[
                const Icon(Icons.help_outline, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Presiona el botón para consultar',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: _cargando ? null : _consultar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Consultar ahora',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
