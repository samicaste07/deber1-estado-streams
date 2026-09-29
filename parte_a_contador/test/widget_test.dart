import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/main.dart';
import 'package:parte_a_contador/presentation/estado/contador_provider.dart';

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
  testWidgets('Flujo de navegación y actualización reactiva con Riverpod', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeContadorRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [contadorRepositoryProvider.overrideWithValue(fakeRepo)],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Comprobar que inicia en 0
    expect(find.text('Contador: 0'), findsOneWidget);

    // Navegar a PantallaControl sin pasar argumentos
    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();

    // Comprobar que en PantallaControl se muestra el valor actual
    expect(find.text('Valor actual: 0'), findsOneWidget);

    // Incrementar en control
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Valor actual: 1'), findsOneWidget);

    // Regresar al Visor con push/pop normal sin devolver valor
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    // El visor observa el provider y ya refleja 1
    expect(find.text('Contador: 1'), findsOneWidget);
  });
}
