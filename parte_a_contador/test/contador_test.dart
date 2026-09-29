import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/data/repositories/contador_prefs_repository.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeContadorRepository implements ContadorRepository {
  int valor = 0;

  @override
  Future<int> leer() async => valor;

  @override
  Future<void> guardar(int nuevo) async {
    valor = nuevo;
  }
}

void main() {
  group('Domain UseCases', () {
    late FakeContadorRepository repo;

    setUp(() {
      repo = FakeContadorRepository();
    });

    test('ObtenerContador devuelve el valor actual', () async {
      repo.valor = 42;
      final useCase = ObtenerContador(repo);
      final resultado = await useCase();
      expect(resultado, 42);
    });

    test('Incrementar suma 1, guarda y devuelve nuevo valor', () async {
      repo.valor = 10;
      final useCase = Incrementar(repo);
      final resultado = await useCase();
      expect(resultado, 11);
      expect(repo.valor, 11);
    });

    test('Decrementar resta 1, guarda y devuelve nuevo valor', () async {
      repo.valor = 10;
      final useCase = Decrementar(repo);
      final resultado = await useCase();
      expect(resultado, 9);
      expect(repo.valor, 9);
    });
  });

  group('ContadorPrefsRepository', () {
    test('leer() devuelve 0 si no existe la clave contador', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = ContadorPrefsRepository();
      final valor = await repository.leer();
      expect(valor, 0);
    });

    test('leer() devuelve el valor guardado si existe', () async {
      SharedPreferences.setMockInitialValues({'contador': 7});
      final repository = ContadorPrefsRepository();
      final valor = await repository.leer();
      expect(valor, 7);
    });

    test('guardar() almacena el valor en shared_preferences', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = ContadorPrefsRepository();
      await repository.guardar(15);
      final valorLeido = await repository.leer();
      expect(valorLeido, 15);
    });
  });
}
