import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/data/repositories/conexion_plus_repository.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';

class FakeConexionRepository implements ConexionRepository {
  EstadoConexion estadoActual = EstadoConexion.sinConexion;
  final StreamController<EstadoConexion> _controller =
      StreamController<EstadoConexion>.broadcast();

  @override
  Future<EstadoConexion> consultarAhora() async => estadoActual;

  @override
  Stream<EstadoConexion> observarCambios() => _controller.stream;

  void emitir(EstadoConexion estado) => _controller.add(estado);
}

class FakeConnectivity implements Connectivity {
  List<ConnectivityResult> checkResult = [ConnectivityResult.none];
  final StreamController<List<ConnectivityResult>> _controller =
      StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => checkResult;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _controller.stream;

  void emitir(List<ConnectivityResult> results) => _controller.add(results);
}

void main() {
  group('Usecases', () {
    late FakeConexionRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeConexionRepository();
    });

    test('ConsultarConexion devuelve el estado del repositorio', () async {
      fakeRepo.estadoActual = EstadoConexion.wifi;
      final usecase = ConsultarConexion(fakeRepo);

      final resultado = await usecase();
      expect(resultado, EstadoConexion.wifi);
    });

    test('ObservarConexion emite los cambios del repositorio', () async {
      final usecase = ObservarConexion(fakeRepo);

      expectLater(
        usecase(),
        emitsInOrder([EstadoConexion.datosMoviles, EstadoConexion.sinConexion]),
      );

      fakeRepo.emitir(EstadoConexion.datosMoviles);
      fakeRepo.emitir(EstadoConexion.sinConexion);
    });
  });

  group('ConexionPlusRepository', () {
    late FakeConnectivity fakeConnectivity;
    late ConexionPlusRepository repository;

    setUp(() {
      fakeConnectivity = FakeConnectivity();
      repository = ConexionPlusRepository(connectivity: fakeConnectivity);
    });

    test('Prioriza wifi si la lista contiene wifi y mobile', () async {
      fakeConnectivity.checkResult = [
        ConnectivityResult.mobile,
        ConnectivityResult.wifi,
      ];

      final estado = await repository.consultarAhora();
      expect(estado, EstadoConexion.wifi);
    });

    test(
      'Devuelve datosMoviles si la lista contiene mobile y no wifi',
      () async {
        fakeConnectivity.checkResult = [
          ConnectivityResult.mobile,
          ConnectivityResult.vpn,
        ];

        final estado = await repository.consultarAhora();
        expect(estado, EstadoConexion.datosMoviles);
      },
    );

    test(
      'Devuelve otro si hay una conexion distinta de wifi y mobile',
      () async {
        fakeConnectivity.checkResult = [ConnectivityResult.ethernet];

        final estado = await repository.consultarAhora();
        expect(estado, EstadoConexion.otro);
      },
    );

    test('Devuelve sinConexion si la lista contiene none', () async {
      fakeConnectivity.checkResult = [ConnectivityResult.none];

      final estado = await repository.consultarAhora();
      expect(estado, EstadoConexion.sinConexion);
    });

    test('Devuelve sinConexion si la lista esta vacia', () async {
      fakeConnectivity.checkResult = [];

      final estado = await repository.consultarAhora();
      expect(estado, EstadoConexion.sinConexion);
    });

    test('observarCambios traduce el stream correctamente', () async {
      expectLater(
        repository.observarCambios(),
        emitsInOrder([
          EstadoConexion.wifi,
          EstadoConexion.datosMoviles,
          EstadoConexion.otro,
          EstadoConexion.sinConexion,
        ]),
      );

      fakeConnectivity.emitir([ConnectivityResult.wifi]);
      fakeConnectivity.emitir([ConnectivityResult.mobile]);
      fakeConnectivity.emitir([ConnectivityResult.bluetooth]);
      fakeConnectivity.emitir([ConnectivityResult.none]);
    });
  });
}
