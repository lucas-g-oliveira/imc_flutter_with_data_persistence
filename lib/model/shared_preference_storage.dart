import 'package:shared_preferences/shared_preferences.dart';

class StorageSharedPreferenceAltura {
  final String key = "altura";

  Future<String> getAltura() async {
    final SharedPreferences altura = await SharedPreferences.getInstance();
    String? valor = altura.getString(key);
    if (valor != null) {
      return valor;
    }
    altura.setString(key, '0');
    String result = altura.getString(key)!;
    return result;
  }

  Future<void> setAltura(String value) async {
    final SharedPreferences altura = await SharedPreferences.getInstance();
    altura.setString(key, value);
  }
}
