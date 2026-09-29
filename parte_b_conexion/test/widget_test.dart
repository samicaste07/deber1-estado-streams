import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class MockConexionRepository implements ConexionRepository {
  final StreamController<EstadoConexion> streamController =
      StreamController<EstadoConexion>.broadcast();

  @override
  Future<EstadoConexion> consultarAhora() async => EstadoConexion.wifi;

  @override
  Stream<EstadoConexion> observarCambios() => streamController.stream;
}

void main() {
  testWidgets('MyApp muestra HomeScreen con BottomNavigationBar', (
    WidgetTester tester,
  ) async {
    final mockRepo = MockConexionRepository();
    final consultar = ConsultarConexion(mockRepo);
    final observar = ObservarConexion(mockRepo);

    await tester.pumpWidget(
      MyApp(consultarConexion: consultar, observarConexion: observar),
    );

    // Verifica que existan ambas pestañas en el BottomNavigationBar
    expect(find.text('Con Future'), findsOneWidget);
    expect(find.text('Con Stream'), findsOneWidget);

    // Inicialmente se muestra la pantalla de Future
    expect(find.text('Estado de Conexión (Foto)'), findsOneWidget);

    // Cambiamos a la pestaña "Con Stream"
    await tester.tap(find.text('Con Stream'));
    await tester.pumpAndSettle();

    expect(find.text('Estado de Conexión (Stream)'), findsOneWidget);
  });
}
