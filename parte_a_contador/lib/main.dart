import 'package:flutter/material.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = ContadorPrefsRepository();
  final obtenerContador = ObtenerContador(repository);
  final incrementar = Incrementar(repository);
  final decrementar = Decrementar(repository);

  runApp(
    MyApp(
      obtenerContador: obtenerContador,
      incrementar: incrementar,
      decrementar: decrementar,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  const MyApp({
    super.key,
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador Clean Architecture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PantallaVisor(
        obtenerContador: obtenerContador,
        incrementar: incrementar,
        decrementar: decrementar,
      ),
    );
  }
}
