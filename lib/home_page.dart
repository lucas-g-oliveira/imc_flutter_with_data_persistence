import 'package:flutter/material.dart';
import 'package:imc_persistance/classes/pessoa.dart';
import 'package:imc_persistance/list_item_builder_custom.dart';
import 'package:imc_persistance/model/shared_preference_storage.dart';
import 'package:imc_persistance/model/hive_storage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> dataList = [];
  Pessoa pessoa = Pessoa();
  String? alturaShareP;

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    alturaShareP = await StorageSharedPreferenceAltura().getAltura();
    dataList = await StorageHive().getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController pesoController = TextEditingController();
    TextEditingController alturaController = TextEditingController();

    alturaController.text = alturaShareP ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => listItemBuilder(dataList[index]),
          itemCount: dataList.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext bc) {
                return AlertDialog(
                  title: const Text('Novo calculo de IMC',
                      textAlign: TextAlign.center),
                  content: Wrap(
                    children: [
                      Column(children: [
                        const Text("Peso(Kg)"),
                        TextField(
                            controller: pesoController,
                            keyboardType: TextInputType.number),
                        const SizedBox(height: 10, width: 10),
                        const Text("Altura(M)"),
                        TextField(
                          controller: alturaController,
                          keyboardType: TextInputType.number,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  pesoController.text = "";
                                  alturaController.text = alturaShareP ?? "";
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  pessoa.setPeso(pesoController.text);
                                  pessoa.setAltura(alturaController.text);
                                  StorageHive().save(pessoa);
                                  Navigator.pop(context);
                                  pesoController.text = "";
                                  alturaShareP = alturaController.text;
                                  StorageSharedPreferenceAltura()
                                      .setAltura(alturaController.text);
                                  loadData();
                                },
                                child: const Text(
                                  "Calcular",
                                )),
                          ],
                        )
                      ]),
                    ],
                  ),
                );
              });
        },
        tooltip: null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
