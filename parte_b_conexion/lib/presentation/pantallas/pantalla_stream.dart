import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  final ConsultarConexion? consultarConexion;
  final ObservarConexion? observarConexion;
  final ConexionCubit? cubit;

  const PantallaStream({
    super.key,
    this.consultarConexion,
    this.observarConexion,
    this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: const _PantallaStreamVista(),
      );
    }

    return BlocProvider(
      create: (context) =>
          ConexionCubit(consultarConexion!, observarConexion!)..iniciar(),
      child: const _PantallaStreamVista(),
    );
  }
}

class _PantallaStreamVista extends StatefulWidget {
  const _PantallaStreamVista();

  @override
  State<_PantallaStreamVista> createState() => _PantallaStreamVistaState();
}

class _PantallaStreamVistaState extends State<_PantallaStreamVista> {
  int _contadorCambios = 0;

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
    return BlocListener<ConexionCubit, EstadoConexion>(
      listener: (context, state) {
        setState(() {
          _contadorCambios++;
        });
      },
      child: BlocBuilder<ConexionCubit, EstadoConexion>(
        builder: (context, estado) {
          final detalles = _obtenerDetallesVisuales(estado);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Estado de Conexión (Stream)'),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 14.0,
                        ),
                        child: Text(
                          'Cambios recibidos: $_contadorCambios',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
