import 'package:flutter/material.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/usecases/consultar_conexion.dart';
import 'domain/usecases/observar_conexion.dart';
import 'presentation/pantallas/pantalla_foto.dart';
import 'presentation/pantallas/pantalla_stream.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = ConexionPlusRepository();
  final consultarConexion = ConsultarConexion(repository);
  final observarConexion = ObservarConexion(repository);

  runApp(
    MyApp(
      consultarConexion: consultarConexion,
      observarConexion: observarConexion,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ConsultarConexion? consultarConexion;
  final ObservarConexion? observarConexion;

  const MyApp({super.key, this.consultarConexion, this.observarConexion});

  @override
  Widget build(BuildContext context) {
    final repo = (consultarConexion == null || observarConexion == null)
        ? ConexionPlusRepository()
        : null;

    final consultar = consultarConexion ?? ConsultarConexion(repo!);
    final observar = observarConexion ?? ObservarConexion(repo!);

    return MaterialApp(
      title: 'Estado de Conexión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(
        consultarConexion: consultar,
        observarConexion: observar,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  const HomeScreen({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PantallaFoto(consultarConexion: widget.consultarConexion),
          PantallaStream(
            consultarConexion: widget.consultarConexion,
            observarConexion: widget.observarConexion,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Con Future',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stream),
            label: 'Con Stream',
          ),
        ],
      ),
    );
  }
}
