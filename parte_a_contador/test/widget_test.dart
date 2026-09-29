import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';

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
  testWidgets(
    'Flujo de navegación y actualización del contador entre visor y control',
    (WidgetTester tester) async {
      final repo = FakeContadorRepository();
      final obtenerContador = ObtenerContador(repo);
      final incrementar = Incrementar(repo);
      final decrementar = Decrementar(repo);

      await tester.pumpWidget(
        MyApp(
          obtenerContador: obtenerContador,
          incrementar: incrementar,
          decrementar: decrementar,
        ),
      );
      await tester.pumpAndSettle();

      // Comprobar que inicia en 0
      expect(find.text('Contador: 0'), findsOneWidget);

      // Navegar a PantallaControl
      await tester.tap(find.text('Ir a Control'));
      await tester.pumpAndSettle();

      // Verificar que estamos en PantallaControl
      expect(find.text('Valor actual: 0'), findsOneWidget);

      // Incrementar en control
      await tester.tap(find.text('+1'));
      await tester.pumpAndSettle();
      expect(find.text('Valor actual: 1'), findsOneWidget);

      // Regresar al Visor con el botón Volver
      await tester.tap(find.text('Volver'));
      await tester.pumpAndSettle();

      // Verificar que el visor se actualizó con setState al regresar
      expect(find.text('Contador: 1'), findsOneWidget);
    },
  );
}
