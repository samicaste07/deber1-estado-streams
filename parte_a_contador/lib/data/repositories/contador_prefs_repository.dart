import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/contador_repository.dart';

class ContadorPrefsRepository implements ContadorRepository {
  static const String _keyContador = 'contador';
  final SharedPreferences? _prefs;

  ContadorPrefsRepository([this._prefs]);

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<int> leer() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_keyContador) ?? 0;
  }

  @override
  Future<void> guardar(int valor) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_keyContador, valor);
  }
}
