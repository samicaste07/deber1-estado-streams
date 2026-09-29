import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';

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
  group('ConexionCubit', () {
    late MockConexionRepository mockRepo;
    late ConsultarConexion consultarConexion;
    late ObservarConexion observarConexion;
    late ConexionCubit cubit;

    setUp(() {
      mockRepo = MockConexionRepository();
      consultarConexion = ConsultarConexion(mockRepo);
      observarConexion = ObservarConexion(mockRepo);
      cubit = ConexionCubit(consultarConexion, observarConexion);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('Estado inicial es EstadoConexion.otro', () {
      expect(cubit.state, EstadoConexion.otro);
    });

    test(
      'iniciar() emite primero la consulta y luego los cambios del stream',
      () async {
        mockRepo.estadoConsulta = EstadoConexion.wifi;

        final expectFuture = expectLater(
          cubit.stream,
          emitsInOrder([
            EstadoConexion.wifi,
            EstadoConexion.datosMoviles,
            EstadoConexion.sinConexion,
          ]),
        );

        await cubit.iniciar();

        mockRepo.streamController.add(EstadoConexion.datosMoviles);
        mockRepo.streamController.add(EstadoConexion.sinConexion);

        await expectFuture;
      },
    );

    test('close() cancela la suscripcion del stream', () async {
      await cubit.iniciar();
      await cubit.close();

      expect(cubit.isClosed, isTrue);
    });
  });
}
