import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/pantallas/pantalla_stream.dart';

class MockConexionRepository implements ConexionRepository {
  EstadoConexion estadoConsulta = EstadoConexion.wifi;
  final StreamController<EstadoConexion> streamController =
      StreamController<EstadoConexion>.broadcast();

  @override
  Future<EstadoConexion> consultarAhora() async => estadoConsulta;

  @override
  Stream<EstadoConexion> observarCambios() => streamController.stream;
}

void main() {
  late MockConexionRepository mockRepo;
  late ConsultarConexion consultarConexion;
  late ObservarConexion observarConexion;

  setUp(() {
    mockRepo = MockConexionRepository();
    consultarConexion = ConsultarConexion(mockRepo);
    observarConexion = ObservarConexion(mockRepo);
  });

  Widget crearWidget() {
    return MaterialApp(
      home: PantallaStream(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      ),
    );
  }

  testWidgets('PantallaStream muestra estado actual y contador de cambios', (
    tester,
  ) async {
    mockRepo.estadoConsulta = EstadoConexion.wifi;

    await tester.pumpWidget(crearWidget());
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.byIcon(Icons.wifi), findsOneWidget);
    expect(find.text('Cambios recibidos: 1'), findsOneWidget);

    mockRepo.streamController.add(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexion'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    expect(find.text('Cambios recibidos: 2'), findsOneWidget);

    mockRepo.streamController.add(EstadoConexion.datosMoviles);
    await tester.pumpAndSettle();

    expect(find.text('Datos moviles'), findsOneWidget);
    expect(find.byIcon(Icons.signal_cellular_alt), findsOneWidget);
    expect(find.text('Cambios recibidos: 3'), findsOneWidget);
  });
}
