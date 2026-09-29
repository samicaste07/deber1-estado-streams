import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/contador_prefs_repository.dart';
import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

// Provider que expone el repositorio
final contadorRepositoryProvider = Provider<ContadorRepository>((ref) {
  return ContadorPrefsRepository();
});

// Estructura que expone el repositorio junto con los casos de uso
class ContadorCasosDeUso {
  final ContadorRepository repository;
  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  const ContadorCasosDeUso({
    required this.repository,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });
}

// Provider que expone el repositorio y los casos de uso
final casosDeUsoContadorProvider = Provider<ContadorCasosDeUso>((ref) {
  final repository = ref.watch(contadorRepositoryProvider);
  return ContadorCasosDeUso(
    repository: repository,
    obtenerContador: ObtenerContador(repository),
    incrementar: Incrementar(repository),
    decrementar: Decrementar(repository),
  );
});

// Providers individuales para facilitar acceso si se requiere
final obtenerContadorProvider = Provider<ObtenerContador>((ref) {
  return ref.watch(casosDeUsoContadorProvider).obtenerContador;
});

final incrementarProvider = Provider<Incrementar>((ref) {
  return ref.watch(casosDeUsoContadorProvider).incrementar;
});

final decrementarProvider = Provider<Decrementar>((ref) {
  return ref.watch(casosDeUsoContadorProvider).decrementar;
});

// Provider de estado del contador
class ContadorNotifier extends Notifier<int> {
  @override
  int build() {
    Future.microtask(cargar);
    return 0;
  }

  Future<void> cargar() async {
    final casos = ref.read(casosDeUsoContadorProvider);
    final valor = await casos.obtenerContador();
    state = valor;
  }

  Future<void> incrementar() async {
    final casos = ref.read(casosDeUsoContadorProvider);
    final nuevoValor = await casos.incrementar();
    state = nuevoValor;
  }

  Future<void> decrementar() async {
    final casos = ref.read(casosDeUsoContadorProvider);
    final nuevoValor = await casos.decrementar();
    state = nuevoValor;
  }
}

final contadorProvider = NotifierProvider<ContadorNotifier, int>(
  ContadorNotifier.new,
);
