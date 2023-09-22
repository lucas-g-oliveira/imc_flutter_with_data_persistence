import 'package:imc_persistance/classes/imc.dart';
import 'package:imc_persistance/interfaces/i_pessoa.dart';
import 'package:hive/hive.dart';

final class StorageHive {
  late Box<dynamic> dataList;
  String key = "data";

  Future<List<Map<String, dynamic>>> getData() async {
    if (Hive.isBoxOpen(key)) {
      dataList = Hive.box(key);
      print("abrindo a caixa");
    } else {
      dataList = await Hive.openBox(key);
      print("criando e abrindo a caixa");
    }
    var all = dataList.get('data') ?? [];
    print(all.runtimeType);
    print(all);

    List<Map<String, dynamic>> formatedData = [];

    for (var each in all) {
      formatedData.add({
        "date": each["date"],
        "peso": each["peso"],
        "altura": each["altura"],
        "imc": each["imc"],
        "situação": each["situação"],
      });
    }
    return formatedData;
  }

  Map<String, dynamic> _parseToInfoData(PessoaInterface people) {
    var imc = CalcularIMC(pessoa: people).execute();
    var d = DateTime.now();
    Map<String, dynamic> user = {
      "date":
          "${d.day}/${d.month}/${d.year} - ${d.hour}:${d.minute}:${d.second}",
      "peso": people.getPeso(),
      "altura": people.getAltura(),
      "imc": imc['imc'],
      "situação": imc['result'],
    };
    return user;
  }

  Future<void> save(PessoaInterface people) async {
    var data = await getData();
    data.add(_parseToInfoData(people));
    print("gravando");
    print(data);
    dataList.put(key, data);
  }
}
