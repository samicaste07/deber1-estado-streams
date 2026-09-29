import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _subscription;

  ConexionCubit(this._consultarConexion, this._observarConexion)
    : super(EstadoConexion.otro);

  Future<void> iniciar() async {
    final estadoInicial = await _consultarConexion();
    if (!isClosed) {
      emit(estadoInicial);
    }

    await _subscription?.cancel();
    _subscription = _observarConexion().listen((nuevoEstado) {
      if (!isClosed) {
        emit(nuevoEstado);
      }
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
