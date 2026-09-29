import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  ContadorCubit(this._obtenerContador, this._incrementar, this._decrementar)
    : super(0);

  Future<void> cargar() async {
    final valor = await _obtenerContador();
    if (!isClosed) {
      emit(valor);
    }
  }

  Future<void> incrementar() async {
    final nuevoValor = await _incrementar();
    if (!isClosed) {
      emit(nuevoValor);
    }
  }

  Future<void> decrementar() async {
    final nuevoValor = await _decrementar();
    if (!isClosed) {
      emit(nuevoValor);
    }
  }
}
