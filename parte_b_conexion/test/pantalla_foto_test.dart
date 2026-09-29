import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/presentation/pantallas/pantalla_foto.dart';

class MockConexionRepository implements ConexionRepository {
  EstadoConexion resultado = EstadoConexion.sinConexion;

  @override
  Future<EstadoConexion> consultarAhora() async => resultado;

  @override
  Stream<EstadoConexion> observarCambios() {
    throw UnimplementedError('No se deben usar streams en PantallaFoto');
  }
}

void main() {
  late MockConexionRepository mockRepository;
  late ConsultarConexion consultarConexion;

  setUp(() {
    mockRepository = MockConexionRepository();
    consultarConexion = ConsultarConexion(mockRepository);
  });

  Widget crearWidget() {
    return MaterialApp(
      home: PantallaFoto(consultarConexion: consultarConexion),
    );
  }

  testWidgets('Muestra texto inicial y boton Consultar ahora', (tester) async {
    await tester.pumpWidget(crearWidget());

    expect(find.text('Consultar ahora'), findsOneWidget);
    expect(find.text('Presiona el botón para consultar'), findsOneWidget);
  });

  testWidgets('Al presionar el boton muestra Wi-Fi en verde y la hora', (
    tester,
  ) async {
    mockRepository.resultado = EstadoConexion.wifi;
    await tester.pumpWidget(crearWidget());

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    final textWidget = tester.widget<Text>(find.text('Wi-Fi'));
    expect(textWidget.style?.color, Colors.green);

    expect(find.byIcon(Icons.wifi), findsOneWidget);
    final iconWidget = tester.widget<Icon>(find.byIcon(Icons.wifi));
    expect(iconWidget.color, Colors.green);

    expect(find.textContaining('Hora de consulta:'), findsOneWidget);
  });

  testWidgets('Al presionar el boton muestra Datos moviles en verde', (
    tester,
  ) async {
    mockRepository.resultado = EstadoConexion.datosMoviles;
    await tester.pumpWidget(crearWidget());

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Datos moviles'), findsOneWidget);
    final textWidget = tester.widget<Text>(find.text('Datos moviles'));
    expect(textWidget.style?.color, Colors.green);
    expect(find.byIcon(Icons.signal_cellular_alt), findsOneWidget);
  });

  testWidgets('Al presionar el boton muestra Sin conexion en rojo', (
    tester,
  ) async {
    mockRepository.resultado = EstadoConexion.sinConexion;
    await tester.pumpWidget(crearWidget());

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Sin conexion'), findsOneWidget);
    final textWidget = tester.widget<Text>(find.text('Sin conexion'));
    expect(textWidget.style?.color, Colors.red);

    expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    final iconWidget = tester.widget<Icon>(find.byIcon(Icons.wifi_off));
    expect(iconWidget.color, Colors.red);
  });
}
