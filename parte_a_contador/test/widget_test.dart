import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';
import 'package:parte_a_contador/presentation/estado/contador_cubit.dart';

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
  testWidgets('Flujo de navegación y actualización reactiva con Bloc / Cubit', (
    WidgetTester tester,
  ) async {
    final fakeRepo = FakeContadorRepository();
    final cubit = ContadorCubit(
      ObtenerContador(fakeRepo),
      Incrementar(fakeRepo),
      Decrementar(fakeRepo),
    );

    await tester.pumpWidget(MyApp(cubit: cubit));
    await tester.pumpAndSettle();

    // Comprobar que inicia en 0
    expect(find.text('Contador: 0'), findsOneWidget);

    // Navegar a PantallaControl sin pasar argumentos
    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();

    // Comprobar que en PantallaControl se muestra el valor actual
    expect(find.text('Valor actual: 0'), findsOneWidget);

    // Incrementar en control usando context.read<ContadorCubit>()
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();
    expect(find.text('Valor actual: 1'), findsOneWidget);

    // Regresar al Visor con Navigator.pop sin devolver valor
    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    // El visor usa BlocBuilder y ya refleja 1
    expect(find.text('Contador: 1'), findsOneWidget);
  });
}
