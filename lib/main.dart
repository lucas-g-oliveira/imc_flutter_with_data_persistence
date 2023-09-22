import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:imc_persistance/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dirDocuments = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dirDocuments.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculo de IMC'),
      debugShowCheckedModeBanner: false,
    );
  }
}
