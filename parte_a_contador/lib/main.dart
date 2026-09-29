import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_cubit.dart';
import 'presentation/pantallas/pantalla_visor.dart';

class ContadorBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('${bloc.runtimeType}: ${change.currentState} -> ${change.nextState}');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = ContadorBlocObserver();

  final repository = ContadorPrefsRepository();
  final obtenerContador = ObtenerContador(repository);
  final incrementar = Incrementar(repository);
  final decrementar = Decrementar(repository);

  runApp(
    BlocProvider(
      create: (context) =>
          ContadorCubit(obtenerContador, incrementar, decrementar)..cargar(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ContadorCubit? cubit;

  const MyApp({super.key, this.cubit});

  @override
  Widget build(BuildContext context) {
    final materialApp = MaterialApp(
      title: 'Contador Bloc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PantallaVisor(),
    );

    if (cubit != null) {
      return BlocProvider.value(value: cubit!, child: materialApp);
    }

    return materialApp;
  }
}
