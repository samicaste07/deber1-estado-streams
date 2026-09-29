import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  final Connectivity _connectivity;

  ConexionPlusRepository({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  @override
  Future<EstadoConexion> consultarAhora() async {
    final results = await _connectivity.checkConnectivity();
    return _mapearConexion(results);
  }

  @override
  Stream<EstadoConexion> observarCambios() {
    return _connectivity.onConnectivityChanged.map(_mapearConexion);
  }

  EstadoConexion _mapearConexion(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }
    if (results.any((result) => result != ConnectivityResult.none)) {
      return EstadoConexion.otro;
    }
    return EstadoConexion.sinConexion;
  }
}
